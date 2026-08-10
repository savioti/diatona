import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/audio/pitch_detection_service.dart';
import '../data/note_spelling.dart';
import '../domain/note_sequence.dart';
import '../domain/sequence_session_state.dart';

final _sequencePitchProvider = Provider<PitchDetectionService>((ref) {
  final service = PitchDetectionService();
  ref.onDispose(service.dispose);
  return service;
});

/// How many times in a row a wrong note has to be detected before it counts as
/// a miss. One reading is often just a glitch of the detector.
const _detectionsPerMiss = 2;

/// Drives a round of playing note sequences, whatever built them.
///
/// The screen listens for the notes of [SequenceSessionState.current] in order,
/// fills them in as they land, and moves on after the last one, after three
/// wrong notes, or when the time limit runs out.
class SequenceTrainingNotifier extends Notifier<SequenceSessionState> {
  final _random = Random();
  Timer? _getReadyTimer;
  Timer? _timeLimitTimer;
  Timer? _advanceTimer;
  Timer? _silenceTimer;
  StreamSubscription<String>? _pitchSub;
  List<NoteSequence> _pool = [];
  Map<NoteSequence, int> _successCounts = {};
  bool _advancing = false;
  bool _waitingForNoteOff = false;
  int? _handledPitchClass;
  int? _wrongPitchClass;
  int _wrongStreak = 0;

  @override
  SequenceSessionState build() {
    ref.onDispose(_cleanup);
    return const SequenceSessionState.idle();
  }

  Future<void> start(List<NoteSequence> pool, int timeLimitSeconds) async {
    _cleanup();
    if (pool.isEmpty) return;
    _pool = pool;
    _successCounts = {for (final s in _pool) s: 0};
    _advancing = false;

    state = SequenceSessionState(
      isActive: true,
      isGetReady: true,
      timeLimitSeconds: timeLimitSeconds,
    );
    _getReadyTimer = Timer(const Duration(seconds: 2), _showFirst);

    final pitchService = ref.read(_sequencePitchProvider);
    await pitchService.start();
    _pitchSub = pitchService.notes.listen(_onPitch);
  }

  void _showFirst() {
    state = state.copyWith(
      isGetReady: false,
      current: _pickNext(null),
      noteIndex: 0,
    );
    _startTimeLimitTimer();
  }

  void _onPitch(String detected) {
    if (state.isGetReady || !state.isActive) return;

    // The last note of a round is usually still ringing when the next one
    // appears, so wait for a short silence before listening again.
    if (_waitingForNoteOff) {
      _silenceTimer?.cancel();
      _silenceTimer = Timer(
        const Duration(milliseconds: 500),
        () => _waitingForNoteOff = false,
      );
      return;
    }

    if (_advancing) return;
    final sequence = state.current;
    if (sequence == null) return;

    final index = state.noteIndex;
    if (index >= sequence.length) return;

    final pitchClass = pitchClassOfDetectedNote(detected);
    if (pitchClass == null) return;

    // The note the user just played is still ringing, it is not an answer to
    // the slot that follows it.
    if (pitchClass == _handledPitchClass) return;

    if (pitchClass != sequence.pitchClasses[index]) {
      _onWrongNote(pitchClass);
      return;
    }

    _handledPitchClass = pitchClass;
    _wrongPitchClass = null;
    _wrongStreak = 0;
    if (index + 1 == sequence.length) {
      _onSuccess();
    } else {
      state = state.copyWith(noteIndex: index + 1);
    }
  }

  void _onWrongNote(int pitchClass) {
    if (pitchClass != _wrongPitchClass) {
      _wrongPitchClass = pitchClass;
      _wrongStreak = 1;
      return;
    }
    if (++_wrongStreak < _detectionsPerMiss) return;

    // A wrong note rings on like any other, so it may only cost one try.
    _handledPitchClass = pitchClass;
    _wrongPitchClass = null;
    _wrongStreak = 0;

    final misses = state.misses + 1;
    state = state.copyWith(misses: misses);
    if (misses >= kSequenceMaxMisses) _onMissedOut();
  }

  void _onSuccess() {
    _advancing = true;
    _waitingForNoteOff = true;
    final sequence = state.current;
    if (sequence != null) {
      _successCounts[sequence] = (_successCounts[sequence] ?? 0) + 1;
    }
    _silenceTimer?.cancel();
    _timeLimitTimer?.cancel();
    _advanceTimer?.cancel();

    state = state.copyWith(
      noteIndex: sequence?.length ?? 0,
      showSuccess: true,
    );
    _scheduleAdvance(const Duration(milliseconds: 900), restartPitch: true);
  }

  void _onMissedOut() {
    _advancing = true;
    _waitingForNoteOff = true;
    _silenceTimer?.cancel();
    _timeLimitTimer?.cancel();
    _advanceTimer?.cancel();

    state = state.copyWith(showMissed: true);
    _scheduleAdvance(const Duration(milliseconds: 1200), restartPitch: true);
  }

  void advance() {
    if (!state.isActive || state.isGetReady || _advancing) return;
    _advancing = true;
    _timeLimitTimer?.cancel();
    _advanceTimer?.cancel();

    state = state.copyWith(showSkip: true);
    _scheduleAdvance(const Duration(milliseconds: 600), restartPitch: false);
  }

  void _scheduleAdvance(Duration delay, {required bool restartPitch}) {
    _advanceTimer = Timer(delay, () {
      _advanceSequence();
      if (restartPitch) unawaited(_restartPitchService());
      _advanceTimer = Timer(
        const Duration(milliseconds: 300),
        () => _advancing = false,
      );
    });
  }

  Future<void> _restartPitchService() async {
    final pitchService = ref.read(_sequencePitchProvider);
    await pitchService.stop();
    if (!state.isActive) return;
    await pitchService.start();
  }

  void _advanceSequence() {
    _handledPitchClass = null;
    _wrongPitchClass = null;
    _wrongStreak = 0;
    state = state.copyWith(
      current: _pickNext(state.current),
      noteIndex: 0,
      misses: 0,
      showSuccess: false,
      showSkip: false,
      showMissed: false,
    );
    _startTimeLimitTimer();
  }

  void stop() {
    _cleanup();
    state = const SequenceSessionState.idle();
  }

  void _startTimeLimitTimer() {
    _timeLimitTimer?.cancel();
    final limit = state.timeLimitSeconds;
    if (limit > 0) {
      _timeLimitTimer = Timer(Duration(seconds: limit), advance);
    }
  }

  NoteSequence _pickNext(NoteSequence? excluded) {
    if (_pool.length == 1) return _pool.first;
    final candidates = excluded != null
        ? _pool.where((s) => s != excluded).toList()
        : List.of(_pool);
    final minCount = candidates.map((s) => _successCounts[s] ?? 0).reduce(min);
    final leastPlayed =
        candidates.where((s) => (_successCounts[s] ?? 0) == minCount).toList();
    return leastPlayed[_random.nextInt(leastPlayed.length)];
  }

  void _cleanup() {
    _getReadyTimer?.cancel();
    _timeLimitTimer?.cancel();
    _advanceTimer?.cancel();
    _silenceTimer?.cancel();
    _pitchSub?.cancel();
    _pitchSub = null;
    _waitingForNoteOff = false;
    _handledPitchClass = null;
    _wrongPitchClass = null;
    _wrongStreak = 0;
    unawaited(ref.read(_sequencePitchProvider).stop());
  }
}

final sequenceTrainingProvider =
    NotifierProvider<SequenceTrainingNotifier, SequenceSessionState>(
  SequenceTrainingNotifier.new,
);
