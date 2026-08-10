import 'package:flutter/material.dart';

import '../../../../core/widgets/answer_buttons.dart';
import '../../domain/ear_training_session_state.dart';
import '../../domain/interval_type.dart';

class IntervalAnswerButtons extends StatelessWidget {
  const IntervalAnswerButtons({
    super.key,
    required this.pool,
    required this.phase,
    required this.answeredInterval,
    required this.correctInterval,
    required this.onAnswer,
  });

  final List<IntervalType> pool;
  final EarTrainingPhase phase;
  final IntervalType? answeredInterval;
  final IntervalType? correctInterval;
  final void Function(IntervalType) onAnswer;

  @override
  Widget build(BuildContext context) => AnswerButtons<IntervalType>(
        values: pool,
        labelOf: (interval) => interval.shortLabel,
        answered: answeredInterval,
        correct: correctInterval,
        revealed: phase == EarTrainingPhase.showingResult,
        enabled: phase == EarTrainingPhase.waitingForAnswer,
        onAnswer: onAnswer,
      );
}
