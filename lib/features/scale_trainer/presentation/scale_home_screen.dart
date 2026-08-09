import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../home/presentation/widgets/interval_selector.dart';
import '../../trainer/data/providers.dart' show settingsRepositoryProvider;
import '../data/providers.dart';
import '../domain/scale_direction.dart';
import '../domain/scale_type.dart';
import 'scale_labels.dart';
import 'scale_training_screen.dart';

class ScaleHomeScreen extends ConsumerWidget {
  const ScaleHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final level = ref.watch(selectedScaleLevelProvider);
    final cumulative = ref.watch(selectedScaleCumulativeProvider);
    final direction = ref.watch(selectedScaleDirectionProvider);
    final naturalRoots = ref.watch(selectedScaleNaturalRootsProvider);
    final interval = ref.watch(selectedScaleIntervalProvider);
    final showNotes = ref.watch(selectedScaleShowNotesProvider);
    final repo = ref.read(settingsRepositoryProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    iconSize: 28,
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.menuScaleTrainer,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 32,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                children: [
                  Text(l10n.level, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    l10n.levelLabel(level, scaleTypeNameForLevel(level, l10n)),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  _LevelSelector(
                    selectedLevel: level,
                    onLevelChanged: (v) {
                      ref.read(selectedScaleLevelProvider.notifier).update(v);
                      repo.saveScaleLevel(v);
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: cumulative,
                        onChanged: (value) {
                          final v = value ?? true;
                          ref
                              .read(selectedScaleCumulativeProvider.notifier)
                              .update(v);
                          repo.saveScaleCumulative(v);
                        },
                      ),
                      Text(
                        l10n.cumulativePool,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 2),
                      IconButton(
                        icon: const Icon(Icons.help_outline, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(l10n.cumulativePoolHelpTitle),
                            content: Text(l10n.cumulativePoolHelpBody),
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
                  ),
                  const SizedBox(height: 24),
                  Text(l10n.scaleDirection, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _DirectionSelector(
                    selected: direction,
                    onChanged: (d) {
                      ref
                          .read(selectedScaleDirectionProvider.notifier)
                          .update(d);
                      repo.saveScaleDirection(d.index);
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(l10n.scaleKeys, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _KeysSelector(
                    naturalRoots: naturalRoots,
                    onChanged: (v) {
                      ref
                          .read(selectedScaleNaturalRootsProvider.notifier)
                          .update(v);
                      repo.saveScaleNaturalRoots(v);
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: showNotes,
                        onChanged: (value) {
                          final v = value ?? false;
                          ref
                              .read(selectedScaleShowNotesProvider.notifier)
                              .update(v);
                          repo.saveScaleShowNotes(v);
                        },
                      ),
                      Text(
                        l10n.scaleShowNotes,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 2),
                      IconButton(
                        icon: const Icon(Icons.help_outline, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(l10n.scaleShowNotesHelpTitle),
                            content: Text(l10n.scaleShowNotesHelpBody),
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
                  ),
                  const SizedBox(height: 24),
                  Text(l10n.timeLimit, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  IntervalSelector(
                    selectedInterval: interval,
                    onIntervalChanged: (v) {
                      ref
                          .read(selectedScaleIntervalProvider.notifier)
                          .update(v);
                      repo.saveScaleInterval(v);
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ScaleTrainingScreen(
                            level: level,
                            timeLimitSeconds: interval,
                            direction: direction,
                            cumulative: cumulative,
                            naturalRootsOnly: naturalRoots,
                            showNotes: showNotes,
                          ),
                        ),
                      ),
                      child: Text(l10n.start),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelSelector extends StatelessWidget {
  const _LevelSelector({
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  final int selectedLevel;
  final ValueChanged<int> onLevelChanged;

  @override
  Widget build(BuildContext context) {
    final maxLevel = ScaleType.values.length;

    return Row(
      children: [
        IconButton.outlined(
          icon: const Icon(Icons.remove),
          onPressed: selectedLevel > 1
              ? () => onLevelChanged(selectedLevel - 1)
              : null,
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 32,
          child: Text(
            '$selectedLevel',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(width: 12),
        IconButton.outlined(
          icon: const Icon(Icons.add),
          onPressed: selectedLevel < maxLevel
              ? () => onLevelChanged(selectedLevel + 1)
              : null,
        ),
      ],
    );
  }
}

class _DirectionSelector extends StatelessWidget {
  const _DirectionSelector({required this.selected, required this.onChanged});

  final ScaleDirection selected;
  final ValueChanged<ScaleDirection> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ScaleDirection.values.map((d) {
        final isSelected = d == selected;
        return FilterChip(
          label: Text(
            scaleDirectionName(d, l10n),
            style: TextStyle(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          onSelected: (_) => onChanged(d),
        );
      }).toList(),
    );
  }
}

class _KeysSelector extends StatelessWidget {
  const _KeysSelector({required this.naturalRoots, required this.onChanged});

  final bool naturalRoots;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final options = {true: l10n.scaleKeysNaturals, false: l10n.scaleKeysAll};

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.entries.map((e) {
        final isSelected = e.key == naturalRoots;
        return FilterChip(
          label: Text(
            e.value,
            style: TextStyle(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          onSelected: (_) => onChanged(e.key),
        );
      }).toList(),
    );
  }
}
