import 'harmony_ear_question.dart';

enum HarmonyEarPhase { idle, playing, waitingForAnswer, showingResult }

class HarmonyEarSessionState {
  const HarmonyEarSessionState({
    this.phase = HarmonyEarPhase.idle,
    this.question,
    this.answeredId,
    this.isCorrect,
    this.correctCount = 0,
    this.totalCount = 0,
    this.streak = 0,
    this.choices = const [],
  });

  final HarmonyEarPhase phase;
  final HarmonyEarQuestion? question;
  final String? answeredId;
  final bool? isCorrect;
  final int correctCount;
  final int totalCount;
  final int streak;
  final List<HarmonyEarChoice> choices;

  double get accuracy => totalCount == 0 ? 0 : correctCount / totalCount;

  HarmonyEarChoice? get correctChoice {
    final id = question?.choiceId;
    if (id == null) return null;
    for (final choice in choices) {
      if (choice.id == id) return choice;
    }
    return null;
  }

  // Sentinel for nullable fields that may be intentionally set to null.
  static const _unset = Object();

  HarmonyEarSessionState copyWith({
    HarmonyEarPhase? phase,
    Object? question = _unset,
    Object? answeredId = _unset,
    Object? isCorrect = _unset,
    int? correctCount,
    int? totalCount,
    int? streak,
    List<HarmonyEarChoice>? choices,
  }) =>
      HarmonyEarSessionState(
        phase: phase ?? this.phase,
        question: question == _unset
            ? this.question
            : question as HarmonyEarQuestion?,
        answeredId:
            answeredId == _unset ? this.answeredId : answeredId as String?,
        isCorrect: isCorrect == _unset ? this.isCorrect : isCorrect as bool?,
        correctCount: correctCount ?? this.correctCount,
        totalCount: totalCount ?? this.totalCount,
        streak: streak ?? this.streak,
        choices: choices ?? this.choices,
      );
}
