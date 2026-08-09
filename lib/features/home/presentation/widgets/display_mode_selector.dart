import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../trainer/domain/chord_display_mode.dart';

class DisplayModeSelector extends StatelessWidget {
  const DisplayModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  final ChordDisplayMode selectedMode;
  final ValueChanged<ChordDisplayMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    String label(ChordDisplayMode mode) => switch (mode) {
          ChordDisplayMode.symbol => l10n.displayModeSymbol,
          ChordDisplayMode.trebleClef => l10n.displayModeTrebleClef,
          ChordDisplayMode.bassClef => l10n.displayModeBassClef,
          ChordDisplayMode.guitar => l10n.displayModeGuitar,
          ChordDisplayMode.ukulele => l10n.displayModeUkulele,
        };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ChordDisplayMode.values.map((mode) {
        final selected = mode == selectedMode;
        return FilterChip(
          label: Text(
            label(mode),
            style: TextStyle(
              color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
          selected: selected,
          onSelected: (_) => onModeChanged(mode),
        );
      }).toList(),
    );
  }
}
