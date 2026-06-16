import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/music_reference.dart';
import 'widgets/caged_system_widget.dart';
import 'widgets/chord_qualities_widget.dart';
import 'widgets/circle_of_fifths_widget.dart';
import 'widgets/harmony_map_widget.dart';
import 'widgets/minor_keys_widget.dart';
import 'widgets/modes_chart_widget.dart';
import 'widgets/pentatonic_boxes_widget.dart';
import 'widgets/rhythm_tree_widget.dart';
import 'widgets/scale_formula_widget.dart';

class ReferenceDetailScreen extends StatelessWidget {
  const ReferenceDetailScreen({super.key, required this.reference});

  final MusicReference reference;

  void _showHelp(BuildContext context) {
    final theme = Theme.of(context);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          reference.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            reference.howItWorks,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left_rounded),
                        iconSize: 28,
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      IconButton(
                        icon: const Icon(Icons.help_outline_rounded),
                        tooltip: l10n.refHowItWorksTooltip,
                        onPressed: () => _showHelp(context),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerRight,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reference.title,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 32,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildInteractiveWidget(reference.type),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveWidget(String type) => switch (type) {
        'circle_of_fifths' => const CircleOfFifthsWidget(),
        'circle_of_fourths' =>
          const CircleOfFifthsWidget(showFourthsDirection: true),
        'harmony_map' => const HarmonyMapWidget(),
        'caged_system' => const CagedSystemWidget(),
        'modes_chart' => const ModesChartWidget(),
        'scale_formula' => const ScaleFormulaWidget(),
        'minor_keys' => const MinorKeysWidget(),
        'chord_qualities' => const ChordQualitiesWidget(),
        'rhythm_tree' => const RhythmTreeWidget(),
        'pentatonic_boxes' => const PentatonicBoxesWidget(),
        _ => const SizedBox.shrink(),
      };
}
