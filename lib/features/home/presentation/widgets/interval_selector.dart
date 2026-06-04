import 'package:flutter/material.dart';

class IntervalSelector extends StatefulWidget {
  const IntervalSelector({
    super.key,
    required this.selectedInterval,
    required this.onIntervalChanged,
  });

  final int selectedInterval;
  final ValueChanged<int> onIntervalChanged;

  @override
  State<IntervalSelector> createState() => _IntervalSelectorState();
}

class _IntervalSelectorState extends State<IntervalSelector> {
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _seconds = widget.selectedInterval == 0 ? 5 : widget.selectedInterval;
  }

  bool get _noLimit => widget.selectedInterval == 0;

  void _decrement() {
    final next = (_seconds - 1).clamp(1, 60);
    setState(() => _seconds = next);
    widget.onIntervalChanged(next);
  }

  void _increment() {
    final next = (_seconds + 1).clamp(1, 60);
    setState(() => _seconds = next);
    widget.onIntervalChanged(next);
  }

  void _toggleNoLimit() {
    if (_noLimit) {
      widget.onIntervalChanged(_seconds);
    } else {
      widget.onIntervalChanged(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        _StepperButton(
          icon: Icons.remove,
          onPressed: _noLimit ? null : _decrement,
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 52,
          child: Text(
            '${_seconds}s',
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(
              color: _noLimit
                  ? colorScheme.onSurface.withValues(alpha: 0.38)
                  : colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _StepperButton(
          icon: Icons.add,
          onPressed: _noLimit ? null : _increment,
        ),
        const SizedBox(width: 16),
        FilterChip(
          label: Text(
            'No limit',
            style: TextStyle(
              color: _noLimit ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
          selected: _noLimit,
          onSelected: (_) => _toggleNoLimit(),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }
}
