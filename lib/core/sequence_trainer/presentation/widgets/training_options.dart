import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';

/// Setup controls shared by the trainer home screens.

/// Minus and plus around the current level.
class LevelStepper extends StatelessWidget {
  const LevelStepper({
    super.key,
    required this.level,
    required this.maxLevel,
    required this.onChanged,
  });

  final int level;
  final int maxLevel;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.outlined(
          icon: const Icon(Icons.remove),
          onPressed: level > 1 ? () => onChanged(level - 1) : null,
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 32,
          child: Text(
            '$level',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(width: 12),
        IconButton.outlined(
          icon: const Icon(Icons.add),
          onPressed: level < maxLevel ? () => onChanged(level + 1) : null,
        ),
      ],
    );
  }
}

/// A checkbox with a label and a question mark that opens an explanation.
class OptionCheckbox extends StatelessWidget {
  const OptionCheckbox({
    super.key,
    required this.value,
    required this.label,
    required this.helpTitle,
    required this.helpBody,
    required this.onChanged,
  });

  final bool value;
  final String label;
  final String helpTitle;
  final String helpBody;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
        ),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(width: 2),
        IconButton(
          icon: const Icon(Icons.help_outline, size: 16),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
          onPressed: () => showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(helpTitle),
              content: Text(helpBody),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(l10n.ok),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A row of chips where exactly one option is selected.
class ChoiceChipRow<T> extends StatelessWidget {
  const ChoiceChipRow({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
  });

  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((value) {
        final isSelected = value == selected;
        return FilterChip(
          label: Text(
            labelOf(value),
            style: TextStyle(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          onSelected: (_) => onChanged(value),
        );
      }).toList(),
    );
  }
}

/// A row of chips where any number of options can be selected, down to a
/// minimum the caller sets.
class MultiChoiceChipRow<T> extends StatelessWidget {
  const MultiChoiceChipRow({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.minSelected = 1,
  });

  final List<T> values;
  final Set<T> selected;
  final String Function(T) labelOf;
  final ValueChanged<Set<T>> onChanged;
  final int minSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((value) {
        final isSelected = selected.contains(value);
        return FilterChip(
          label: Text(
            labelOf(value),
            style: TextStyle(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          onSelected: (wanted) {
            final next = Set<T>.from(selected);
            if (wanted) {
              next.add(value);
            } else if (next.length > minSelected) {
              next.remove(value);
            }
            onChanged(next);
          },
        );
      }).toList(),
    );
  }
}

/// Section title used above each group of controls.
class SetupLabel extends StatelessWidget {
  const SetupLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.titleLarge);
}
