import 'package:flutter/material.dart';

import '../../../../features/trainer/domain/chord_type.dart';

class LevelSelector extends StatelessWidget {
  const LevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  final int selectedLevel;
  final ValueChanged<int> onLevelChanged;

  static const int _minLevel = 1;
  static final int _maxLevel = ChordType.values.length;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        _StepperButton(
          icon: Icons.remove,
          onPressed:
              selectedLevel > _minLevel
                  ? () => onLevelChanged(selectedLevel - 1)
                  : null,
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 32,
          child: Text(
            '$selectedLevel',
            textAlign: TextAlign.center,
            style: textTheme.titleLarge,
          ),
        ),
        const SizedBox(width: 12),
        _StepperButton(
          icon: Icons.add,
          onPressed:
              selectedLevel < _maxLevel
                  ? () => onLevelChanged(selectedLevel + 1)
                  : null,
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
