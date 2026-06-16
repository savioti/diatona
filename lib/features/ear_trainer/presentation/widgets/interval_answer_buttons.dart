import 'package:flutter/material.dart';

import '../../domain/ear_training_session_state.dart';
import '../../domain/interval_type.dart';

enum _ButtonState { normal, correct, wrong, dimmed }

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isResult = phase == EarTrainingPhase.showingResult;
    final isWaiting = phase == EarTrainingPhase.waitingForAnswer;
    final enabled = isWaiting;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: pool.map((interval) {
        final state = _buttonStateFor(interval, isResult);
        return _IntervalButton(
          label: interval.shortLabel,
          buttonState: state,
          enabled: enabled,
          onTap: enabled ? () => onAnswer(interval) : null,
          theme: theme,
        );
      }).toList(),
    );
  }

  _ButtonState _buttonStateFor(IntervalType interval, bool isResult) {
    if (!isResult) return _ButtonState.normal;
    if (interval == correctInterval) return _ButtonState.correct;
    if (interval == answeredInterval) return _ButtonState.wrong;
    return _ButtonState.dimmed;
  }
}

class _IntervalButton extends StatelessWidget {
  const _IntervalButton({
    required this.label,
    required this.buttonState,
    required this.enabled,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final _ButtonState buttonState;
  final bool enabled;
  final VoidCallback? onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final Color border;

    switch (buttonState) {
      case _ButtonState.correct:
        bg = Colors.green.shade700;
        fg = Colors.white;
        border = Colors.green.shade700;
      case _ButtonState.wrong:
        bg = Colors.red.shade700;
        fg = Colors.white;
        border = Colors.red.shade700;
      case _ButtonState.dimmed:
        bg = theme.colorScheme.surface;
        fg = theme.colorScheme.onSurface.withAlpha(80);
        border = theme.colorScheme.outline.withAlpha(60);
      case _ButtonState.normal:
        bg = theme.colorScheme.surface;
        fg = theme.colorScheme.onSurface;
        border = theme.colorScheme.outline.withAlpha(160);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
