import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audio/audio_service.dart';
import '../../audio/pitch_detection_service.dart';
import '../data/note_data.dart';
import '../domain/note_clef.dart';
import '../domain/note_item.dart';
import '../domain/note_session_state.dart';

final _noteAudioProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});

final _notePitchProvider = Provider<PitchDetectionService>((ref) {
  final service = PitchDetectionService();
  ref.onDispose(service.dispose);
  return service;
});

class NoteTrainingNotifier extends Notifier<NoteSessionState> {
  final _random = Random();
  Timer? _getReadyTimer;
  Timer? _timeLimitTimer;
  Timer? _successTimer;
  Timer? _silenceTimer;
  StreamSubscription<String>? _pitchSub;
  List<NoteItem> _pool = [];
  Map<NoteItem, int> _successCounts = {};
  bool _advancing = false;
  bool _waitingForNoteOff = false;
  late AudioService _audio;

  @override
  NoteSessionState build() {
    _audio = ref.read(_noteAudioProvider);
    ref.onDispose(_cleanup);
    return const NoteSessionState.idle();
  }

  Future<void> start(
    int timeLimitSeconds,
    NoteClef clef,
    int level, {
    bool cumulative = true,
  }) async {
    _cleanup();
    await _audio.init();
    _pool = cumulative
        ? buildNotePool(clef, level)
        : buildNotePoolSingle(clef, level);
    _successCounts = {for (final n in _pool) n: 0};
    _advancing = false;

    final pitchService = ref.read(_notePitchProvider);
    await pitchService.start();
    _pitchSub = pitchService.notes.listen(_onPitch);

    if (timeLimitSeconds == 0) {
      final note = _pickNextNote(null);
      state = NoteSessionState(
        isActive: true,
        isGetReady: false,
        level: level,
        timeLimitSeconds: timeLimitSeconds,
        clef: clef,
        currentNote: note,
      );
    } else {
      state = NoteSessionState(
        isActive: true,
        isGetReady: true,
        level: level,
        timeLimitSeconds: timeLimitSeconds,
        clef: clef,
      );
      _getReadyTimer = Timer(const Duration(seconds: 2), _showFirstNote);
    }
  }

  void _showFirstNote() {
    final note = _pickNextNote(null);
    state = state.copyWith(isGetReady: false, currentNote: note);
    _startTimeLimitTimer();
  }

  void _onPitch(String detected) {
    if (state.isGetReady || !state.isActive) return;

    if (_waitingForNoteOff) {
      _silenceTimer?.cancel();
      _silenceTimer = Timer(
        const Duration(milliseconds: 500),
        () => _waitingForNoteOff = false,
      );
      return;
    }

    if (_advancing) return;
    final note = state.currentNote;
    if (note == null) return;
    if (detected == note.detectedName) _onSuccess();
  }

  void _onSuccess() {
    _advancing = true;
    _waitingForNoteOff = true;
    final note = state.currentNote;
    if (note != null) _successCounts[note] = (_successCounts[note] ?? 0) + 1;
    _silenceTimer?.cancel();
    _timeLimitTimer?.cancel();
    _successTimer?.cancel();

    unawaited(_audio.playSuccess());
    state = state.copyWith(showSuccess: true);

    _successTimer = Timer(const Duration(milliseconds: 800), () {
      _advanceNote();
      unawaited(_restartPitchService());
      _successTimer = Timer(
        const Duration(milliseconds: 300),
        () => _advancing = false,
      );
    });
  }

  Future<void> _restartPitchService() async {
    final pitchService = ref.read(_notePitchProvider);
    await pitchService.stop();
    if (!state.isActive) return;
    await pitchService.start();
  }

  void advance() {
    if (!state.isActive || state.isGetReady || _advancing) return;
    _advancing = true;
    _timeLimitTimer?.cancel();
    _successTimer?.cancel();
    _advanceNote();
    _successTimer = Timer(
      const Duration(milliseconds: 300),
      () => _advancing = false,
    );
  }

  void _advanceNote() {
    final next = _pickNextNote(state.currentNote);
    state = state.copyWith(currentNote: next, showSuccess: false);
    _startTimeLimitTimer();
  }

  void stop() {
    _cleanup();
    state = const NoteSessionState.idle();
  }

  void _startTimeLimitTimer() {
    _timeLimitTimer?.cancel();
    final limit = state.timeLimitSeconds;
    if (limit > 0) {
      _timeLimitTimer = Timer(Duration(seconds: limit), advance);
    }
  }

  NoteItem _pickNextNote(NoteItem? excluded) {
    if (_pool.length == 1) return _pool.first;
    final candidates = excluded != null
        ? _pool.where((n) => n != excluded).toList()
        : List.of(_pool);
    final minCount =
        candidates.map((n) => _successCounts[n] ?? 0).reduce(min);
    final leastPlayed = candidates
        .where((n) => (_successCounts[n] ?? 0) == minCount)
        .toList();
    return leastPlayed[_random.nextInt(leastPlayed.length)];
  }

  void _cleanup() {
    _getReadyTimer?.cancel();
    _timeLimitTimer?.cancel();
    _successTimer?.cancel();
    _silenceTimer?.cancel();
    _pitchSub?.cancel();
    _pitchSub = null;
    _waitingForNoteOff = false;
    unawaited(ref.read(_notePitchProvider).stop());
  }
}

final noteTrainingProvider =
    NotifierProvider<NoteTrainingNotifier, NoteSessionState>(
  NoteTrainingNotifier.new,
);
