import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../audio/piano_playback_service.dart';
import '../domain/ear_training_question.dart';
import '../domain/ear_training_session_state.dart';
import '../domain/interval_direction.dart';
import '../domain/interval_type.dart';

final _pianoServiceProvider = Provider<PianoPlaybackService>(
  (_) => PianoPlaybackService(),
);

final earTrainingProvider =
    NotifierProvider<EarTrainingNotifier, EarTrainingSessionState>(
  EarTrainingNotifier.new,
);

class EarTrainingNotifier extends Notifier<EarTrainingSessionState> {
  final _rng = Random();
  IntervalType? _lastInterval;

  @override
  EarTrainingSessionState build() => const EarTrainingSessionState();

  PianoPlaybackService get _piano => ref.read(_pianoServiceProvider);

  Future<void> start(List<IntervalType> pool, IntervalDirection direction) async {
    state = EarTrainingSessionState(pool: pool, direction: direction);
    await _piano.init();
    _generateAndPlay();
  }

  /// Replays the current question audio.
  void replay() {
    final q = state.question;
    if (q == null) return;
    state = state.copyWith(phase: EarTrainingPhase.playing);
    _playQuestion(q);
  }

  void submitAnswer(IntervalType answer) {
    final q = state.question;
    if (q == null || state.phase != EarTrainingPhase.waitingForAnswer) return;

    final isCorrect = answer == q.interval;
    final prev = state.perIntervalStats[q.interval] ?? const IntervalStat();
    final newStats = Map<IntervalType, IntervalStat>.from(state.perIntervalStats)
      ..[q.interval] = prev.copyWith(
        correct: prev.correct + (isCorrect ? 1 : 0),
        total: prev.total + 1,
      );

    state = state.copyWith(
      phase: EarTrainingPhase.showingResult,
      answeredInterval: answer,
      isCorrect: isCorrect,
      correctCount: state.correctCount + (isCorrect ? 1 : 0),
      totalCount: state.totalCount + 1,
      streak: isCorrect ? state.streak + 1 : 0,
      perIntervalStats: newStats,
    );
  }

  void nextQuestion() {
    if (state.phase != EarTrainingPhase.showingResult) return;
    state = state.copyWith(
      phase: EarTrainingPhase.playing,
      answeredInterval: null,
      isCorrect: null,
    );
    _generateAndPlay();
  }

  Future<void> stop() async {
    await _piano.stop();
    state = const EarTrainingSessionState();
  }

  void _generateAndPlay() {
    final q = _pickQuestion();
    _lastInterval = q.interval;
    state = state.copyWith(question: q, phase: EarTrainingPhase.playing);
    _playQuestion(q);
  }

  void _playQuestion(EarTrainingQuestion q) {
    unawaited(_piano.play(q, onComplete: () {
      if (state.phase == EarTrainingPhase.playing) {
        state = state.copyWith(phase: EarTrainingPhase.waitingForAnswer);
      }
    }));
  }

  EarTrainingQuestion _pickQuestion() {
    final pool = state.pool;

    // Avoid consecutive repeat when pool has more than one choice.
    IntervalType interval;
    do {
      interval = pool[_rng.nextInt(pool.length)];
    } while (pool.length > 1 && interval == _lastInterval);

    // Resolve direction (expand 'random' to a concrete direction).
    final IntervalDirection dir;
    if (state.direction == IntervalDirection.random) {
      const concrete = [
        IntervalDirection.ascending,
        IntervalDirection.descending,
        IntervalDirection.harmonic,
      ];
      dir = concrete[_rng.nextInt(concrete.length)];
    } else {
      dir = state.direction;
    }

    final semitones = interval.semitones;
    final int firstMidi;
    final int secondMidi;

    if (dir == IntervalDirection.descending) {
      // First note is higher; constrain so second stays within range.
      final minFirst = PianoPlaybackService.midiMin + semitones;
      final maxFirst = PianoPlaybackService.midiMax;
      firstMidi = minFirst + _rng.nextInt(maxFirst - minFirst + 1);
      secondMidi = firstMidi - semitones;
    } else {
      // Ascending or harmonic: first note is lower.
      final minFirst = PianoPlaybackService.midiMin;
      final maxFirst = PianoPlaybackService.midiMax - semitones;
      firstMidi = minFirst + _rng.nextInt(maxFirst - minFirst + 1);
      secondMidi = firstMidi + semitones;
    }

    return EarTrainingQuestion(
      firstMidi: firstMidi,
      secondMidi: secondMidi,
      interval: interval,
      direction: dir,
    );
  }
}
