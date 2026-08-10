import '../../../core/harmony/domain/diatonic_chord.dart';
import 'roman_question.dart';

enum RomanPhase { idle, waitingForAnswer, showingResult }

class RomanSessionState {
  const RomanSessionState({
    this.phase = RomanPhase.idle,
    this.question,
    this.answered,
    this.isCorrect,
    this.correctCount = 0,
    this.totalCount = 0,
    this.streak = 0,
  });

  final RomanPhase phase;
  final RomanQuestion? question;
  final DiatonicChord? answered;
  final bool? isCorrect;
  final int correctCount;
  final int totalCount;
  final int streak;

  double get accuracy => totalCount == 0 ? 0 : correctCount / totalCount;

  // Sentinel for nullable fields that may be intentionally set to null.
  static const _unset = Object();

  RomanSessionState copyWith({
    RomanPhase? phase,
    Object? question = _unset,
    Object? answered = _unset,
    Object? isCorrect = _unset,
    int? correctCount,
    int? totalCount,
    int? streak,
  }) =>
      RomanSessionState(
        phase: phase ?? this.phase,
        question:
            question == _unset ? this.question : question as RomanQuestion?,
        answered:
            answered == _unset ? this.answered : answered as DiatonicChord?,
        isCorrect: isCorrect == _unset ? this.isCorrect : isCorrect as bool?,
        correctCount: correctCount ?? this.correctCount,
        totalCount: totalCount ?? this.totalCount,
        streak: streak ?? this.streak,
      );
}
