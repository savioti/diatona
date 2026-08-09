import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audio/pitch_detection_service.dart';
import '../data/scale_data.dart';
import '../domain/scale_direction.dart';
import '../domain/scale_item.dart';
import '../domain/scale_session_state.dart';

final _scalePitchProvider = Provider<PitchDetectionService>((ref) {
  final service = PitchDetectionService();
  ref.onDispose(service.dispose);
  return service;
});

/// How many times in a row a wrong note has to be detected before it counts as
/// a miss. One reading is often just a glitch of the detector.
const _detectionsPerMiss = 2;

class ScaleTrainingNotifier extends Notifier<ScaleSessionState> {
  final _random = Random();
  Timer? _getReadyTimer;
  Timer? _timeLimitTimer;
  Timer? _successTimer;
  Timer? _silenceTimer;
  StreamSubscription<String>? _pitchSub;
  List<ScaleItem> _pool = [];
  Map<ScaleItem, int> _successCounts = {};
  bool _advancing = false;
  bool _waitingForNoteOff = false;
  int? _handledPitchClass;
  int? _wrongPitchClass;
  int _wrongStreak = 0;

  @override
  ScaleSessionState build() {
    ref.onDispose(_cleanup);
    return const ScaleSessionState.idle();
  }

  Future<void> start(
    int level,
    int timeLimitSeconds,
    ScaleDirection direction, {
    bool cumulative = true,
    bool naturalRootsOnly = true,
  }) async {
    _cleanup();
    _pool = cumulative
        ? buildScalePool(level, direction, naturalRootsOnly: naturalRootsOnly)
        : buildScalePoolSingle(level, direction,
            naturalRootsOnly: naturalRootsOnly);
    if (_pool.isEmpty) return;
    _successCounts = {for (final s in _pool) s: 0};
    _advancing = false;

    state = ScaleSessionState(
      isActive: true,
      isGetReady: true,
      level: level,
      timeLimitSeconds: timeLimitSeconds,
      direction: direction,
    );
    _getReadyTimer = Timer(const Duration(seconds: 2), _showFirstScale);

    final pitchService = ref.read(_scalePitchProvider);
    await pitchService.start();
    _pitchSub = pitchService.notes.listen(_onPitch);
  }

  void _showFirstScale() {
    state = state.copyWith(
      isGetReady: false,
      currentScale: _pickNextScale(null),
      noteIndex: 0,
    );
    _startTimeLimitTimer();
  }

  void _onPitch(String detected) {
    if (state.isGetReady || !state.isActive) return;

    // The last note of a scale is usually still ringing when the next one
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
    final scale = state.currentScale;
    if (scale == null) return;

    final index = state.noteIndex;
    if (index >= scale.length) return;

    final pitchClass = pitchClassOfDetectedNote(detected);
    if (pitchClass == null) return;

    // The note the user just played is still ringing, it is not an answer to
    // the slot that follows it.
    if (pitchClass == _handledPitchClass) return;

    if (pitchClass != scale.pitchClasses[index]) {
      _onWrongNote(pitchClass);
      return;
    }

    _handledPitchClass = pitchClass;
    _wrongPitchClass = null;
    _wrongStreak = 0;
    if (index + 1 == scale.length) {
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
    if (misses >= kScaleMaxMisses) _onMissedOut();
  }

  void _onMissedOut() {
    _advancing = true;
    _waitingForNoteOff = true;
    _silenceTimer?.cancel();
    _timeLimitTimer?.cancel();
    _successTimer?.cancel();

    state = state.copyWith(showMissed: true);

    _successTimer = Timer(const Duration(milliseconds: 1200), () {
      _advanceScale();
      unawaited(_restartPitchService());
      _successTimer = Timer(
        const Duration(milliseconds: 300),
        () => _advancing = false,
      );
    });
  }

  void _onSuccess() {
    _advancing = true;
    _waitingForNoteOff = true;
    final scale = state.currentScale;
    if (scale != null) {
      _successCounts[scale] = (_successCounts[scale] ?? 0) + 1;
    }
    _silenceTimer?.cancel();
    _timeLimitTimer?.cancel();
    _successTimer?.cancel();

    state = state.copyWith(noteIndex: scale?.length ?? 0, showSuccess: true);

    _successTimer = Timer(const Duration(milliseconds: 900), () {
      _advanceScale();
      unawaited(_restartPitchService());
      _successTimer = Timer(
        const Duration(milliseconds: 300),
        () => _advancing = false,
      );
    });
  }

  Future<void> _restartPitchService() async {
    final pitchService = ref.read(_scalePitchProvider);
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
      _advanceScale();
      _successTimer = Timer(
        const Duration(milliseconds: 300),
        () => _advancing = false,
      );
    });
  }

  void _advanceScale() {
    _handledPitchClass = null;
    _wrongPitchClass = null;
    _wrongStreak = 0;
    state = state.copyWith(
      currentScale: _pickNextScale(state.currentScale),
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
    state = const ScaleSessionState.idle();
  }

  void _startTimeLimitTimer() {
    _timeLimitTimer?.cancel();
    final limit = state.timeLimitSeconds;
    if (limit > 0) {
      _timeLimitTimer = Timer(Duration(seconds: limit), advance);
    }
  }

  ScaleItem _pickNextScale(ScaleItem? excluded) {
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
    _successTimer?.cancel();
    _silenceTimer?.cancel();
    _pitchSub?.cancel();
    _pitchSub = null;
    _waitingForNoteOff = false;
    _handledPitchClass = null;
    _wrongPitchClass = null;
    _wrongStreak = 0;
    unawaited(ref.read(_scalePitchProvider).stop());
  }
}

final scaleTrainingProvider =
    NotifierProvider<ScaleTrainingNotifier, ScaleSessionState>(
  ScaleTrainingNotifier.new,
);
