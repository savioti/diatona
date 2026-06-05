import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audio/audio_service.dart';
import '../../audio/pitch_detection_service.dart';
import '../data/chord_data.dart';
import '../domain/chord.dart';
import '../domain/training_session_state.dart';

final _audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});

final _pitchServiceProvider = Provider<PitchDetectionService>((ref) {
  final service = PitchDetectionService();
  ref.onDispose(service.dispose);
  return service;
});

class TrainingNotifier extends Notifier<TrainingSessionState> {
  final _random = Random();
  Timer? _getReadyTimer;
  Timer? _timeLimitTimer;
  Timer? _successTimer;
  Timer? _silenceTimer;
  StreamSubscription<String>? _pitchSub;
  List<Chord> _pool = [];
  Map<Chord, int> _successCounts = {};
  bool _advancing = false;
  bool _waitingForNoteOff = false;
  late AudioService _audio;


  @override
  TrainingSessionState build() {
    _audio = ref.read(_audioServiceProvider);
    ref.onDispose(_cleanup);
    return const TrainingSessionState.idle();
  }

  Future<void> start(int level, int timeLimitSeconds, {bool cumulative = true}) async {
    _cleanup();
    await _audio.init();
    _pool = cumulative ? buildChordPool(level) : buildChordPoolSingle(level);
    _successCounts = {for (final c in _pool) c: 0};
    _advancing = false;

    final pitchService = ref.read(_pitchServiceProvider);
    await pitchService.start();
    _pitchSub = pitchService.notes.listen(_onPitch);

    if (timeLimitSeconds == 0) {
      final chord = _pickNextChord(null);
      state = TrainingSessionState(
        isActive: true,
        isGetReady: false,
        level: level,
        timeLimitSeconds: timeLimitSeconds,
        currentChord: chord,
      );
    } else {
      state = TrainingSessionState(
        isActive: true,
        isGetReady: true,
        level: level,
        timeLimitSeconds: timeLimitSeconds,
      );
      _getReadyTimer = Timer(const Duration(seconds: 2), _showFirstChord);
    }
  }

  void _showFirstChord() {
    final chord = _pickNextChord(null);
    state = state.copyWith(isGetReady: false, currentChord: chord);
    _startTimeLimitTimer();
  }

  void _onPitch(String note) {
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
    final chord = state.currentChord;
    if (chord == null) return;
    final root = chord.rootNote;
    if (note == root || note == chord.altRootNote) _onSuccess();
  }

  void _onSuccess() {
    _advancing = true;
    _waitingForNoteOff = true;
    final chord = state.currentChord;
    if (chord != null) _successCounts[chord] = (_successCounts[chord] ?? 0) + 1;
    _silenceTimer?.cancel();
    _timeLimitTimer?.cancel();
    _successTimer?.cancel();

    unawaited(_audio.playSuccess());
    state = state.copyWith(showSuccess: true);

    _successTimer = Timer(const Duration(milliseconds: 800), () {
      _advanceChord();
      unawaited(_restartPitchService());
      _successTimer = Timer(
        const Duration(milliseconds: 300),
        () => _advancing = false,
      );
    });
  }

  Future<void> _restartPitchService() async {
    final pitchService = ref.read(_pitchServiceProvider);
    await pitchService.stop();
    if (!state.isActive) return;
    await pitchService.start();
  }

  void advance() {
    if (!state.isActive || state.isGetReady || _advancing) return;
    _advancing = true;
    _timeLimitTimer?.cancel();
    _successTimer?.cancel();
    state = state.copyWith(showSkip: true);
    _successTimer = Timer(const Duration(milliseconds: 600), () {
      _advanceChord();
      _successTimer = Timer(
        const Duration(milliseconds: 300),
        () => _advancing = false,
      );
    });
  }

  void _advanceChord() {
    final next = _pickNextChord(state.currentChord);
    state = state.copyWith(currentChord: next, showSuccess: false, showSkip: false);
    _startTimeLimitTimer();
  }

  void stop() {
    _cleanup();
    state = const TrainingSessionState.idle();
  }

  void _startTimeLimitTimer() {
    _timeLimitTimer?.cancel();
    final limit = state.timeLimitSeconds;
    if (limit > 0) {
      _timeLimitTimer = Timer(Duration(seconds: limit), advance);
    }
  }

  Chord _pickNextChord(Chord? excluded) {
    if (_pool.length == 1) return _pool.first;
    final candidates = excluded != null
        ? _pool.where((c) => c != excluded).toList()
        : List.of(_pool);
    final minCount = candidates
        .map((c) => _successCounts[c] ?? 0)
        .reduce(min);
    final leastPlayed =
        candidates.where((c) => (_successCounts[c] ?? 0) == minCount).toList();
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
    unawaited(ref.read(_pitchServiceProvider).stop());
  }
}

final trainingProvider =
    NotifierProvider<TrainingNotifier, TrainingSessionState>(
  TrainingNotifier.new,
);
