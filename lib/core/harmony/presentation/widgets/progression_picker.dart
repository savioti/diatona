import 'package:flutter/material.dart';

import '../../data/progression_data.dart';

/// Picks which progressions a session draws from.
///
/// A row per progression rather than a row of chips: the numerals are what the
/// exercise is about and they are too long to read sideways.
class ProgressionPicker extends StatelessWidget {
  const ProgressionPicker({
    super.key,
    required this.selected,
    required this.onChanged,
    this.minSelected = 1,
  });

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  /// How few may be left selected, so the pool never empties out from under
  /// the start button.
  final int minSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        for (final progression in progressionData)
          CheckboxListTile(
            value: selected.contains(progression.id),
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              progression.name,
              style: theme.textTheme.bodyMedium,
            ),
            subtitle: Text(
              progressionNumerals(progression).join('  '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onChanged: (wanted) {
              final next = Set<String>.from(selected);
              if (wanted ?? false) {
                next.add(progression.id);
              } else if (next.length > minSelected) {
                next.remove(progression.id);
              }
              onChanged(next);
            },
          ),
      ],
    );
  }
}
