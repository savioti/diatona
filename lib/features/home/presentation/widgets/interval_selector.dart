import 'package:flutter/material.dart';

const List<int> kIntervalOptions = [0, 1, 3, 5, 10];

class IntervalSelector extends StatelessWidget {
  const IntervalSelector({
    super.key,
    required this.selectedInterval,
    required this.onIntervalChanged,
  });

  final int selectedInterval;
  final ValueChanged<int> onIntervalChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: kIntervalOptions.indexed.map((entry) {
        final (i, value) = entry;
        final isSelected = value == selectedInterval;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
            child: GestureDetector(
              onTap: () => onIntervalChanged(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value == 0 ? '∞' : '${value}s',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
