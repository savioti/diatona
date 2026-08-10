import 'package:flutter/material.dart';

/// The choices of a tap-to-answer round, and what became of them once the
/// answer is in: the right one goes green, the one that was picked goes red if
/// it was not the right one, and the rest fade back.
class AnswerButtons<T> extends StatelessWidget {
  const AnswerButtons({
    super.key,
    required this.values,
    required this.labelOf,
    required this.onAnswer,
    this.answered,
    this.correct,
    this.revealed = false,
    this.enabled = true,
  });

  final List<T> values;
  final String Function(T value) labelOf;
  final void Function(T value) onAnswer;

  /// What the user picked, null until they pick.
  final T? answered;

  final T? correct;

  /// Whether the round is over and the answers may be coloured in.
  final bool revealed;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        for (final value in values)
          _AnswerButton(
            label: labelOf(value),
            state: _stateOf(value),
            onTap: enabled ? () => onAnswer(value) : null,
          ),
      ],
    );
  }

  _AnswerState _stateOf(T value) {
    if (!revealed) return _AnswerState.normal;
    if (value == correct) return _AnswerState.correct;
    if (value == answered) return _AnswerState.wrong;
    return _AnswerState.dimmed;
  }
}

enum _AnswerState { normal, correct, wrong, dimmed }

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.label,
    required this.state,
    required this.onTap,
  });

  final String label;
  final _AnswerState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color background;
    final Color foreground;
    final Color border;

    switch (state) {
      case _AnswerState.correct:
        background = Colors.green.shade700;
        foreground = Colors.white;
        border = Colors.green.shade700;
      case _AnswerState.wrong:
        background = Colors.red.shade700;
        foreground = Colors.white;
        border = Colors.red.shade700;
      case _AnswerState.dimmed:
        background = theme.colorScheme.surface;
        foreground = theme.colorScheme.onSurface.withAlpha(80);
        border = theme.colorScheme.outline.withAlpha(60);
      case _AnswerState.normal:
        background = theme.colorScheme.surface;
        foreground = theme.colorScheme.onSurface;
        border = theme.colorScheme.outline.withAlpha(160);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: background,
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
                color: foreground,
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
