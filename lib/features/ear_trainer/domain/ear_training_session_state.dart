import 'ear_training_question.dart';
import 'interval_direction.dart';
import 'interval_type.dart';

enum EarTrainingPhase { idle, playing, waitingForAnswer, showingResult }

class IntervalStat {
  const IntervalStat({this.correct = 0, this.total = 0});

  final int correct;
  final int total;

  IntervalStat copyWith({int? correct, int? total}) => IntervalStat(
        correct: correct ?? this.correct,
        total: total ?? this.total,
      );
}

class EarTrainingSessionState {
  const EarTrainingSessionState({
    this.phase = EarTrainingPhase.idle,
    this.question,
    this.answeredInterval,
    this.isCorrect,
    this.correctCount = 0,
    this.totalCount = 0,
    this.streak = 0,
    this.perIntervalStats = const {},
    this.pool = const [],
    this.direction = IntervalDirection.ascending,
  });

  final EarTrainingPhase phase;
  final EarTrainingQuestion? question;
  final IntervalType? answeredInterval;
  final bool? isCorrect;
  final int correctCount;
  final int totalCount;
  final int streak;
  final Map<IntervalType, IntervalStat> perIntervalStats;
  final List<IntervalType> pool;
  final IntervalDirection direction;

  double get accuracy => totalCount == 0 ? 0 : correctCount / totalCount;

  // Sentinel for nullable fields that may be intentionally set to null.
  static const _unset = Object();

  EarTrainingSessionState copyWith({
    EarTrainingPhase? phase,
    Object? question = _unset,
    Object? answeredInterval = _unset,
    Object? isCorrect = _unset,
    int? correctCount,
    int? totalCount,
    int? streak,
    Map<IntervalType, IntervalStat>? perIntervalStats,
    List<IntervalType>? pool,
    IntervalDirection? direction,
  }) =>
      EarTrainingSessionState(
        phase: phase ?? this.phase,
        question: question == _unset
            ? this.question
            : question as EarTrainingQuestion?,
        answeredInterval: answeredInterval == _unset
            ? this.answeredInterval
            : answeredInterval as IntervalType?,
        isCorrect: isCorrect == _unset ? this.isCorrect : isCorrect as bool?,
        correctCount: correctCount ?? this.correctCount,
        totalCount: totalCount ?? this.totalCount,
        streak: streak ?? this.streak,
        perIntervalStats: perIntervalStats ?? this.perIntervalStats,
        pool: pool ?? this.pool,
        direction: direction ?? this.direction,
      );
}
