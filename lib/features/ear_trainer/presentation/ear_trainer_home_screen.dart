import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../trainer/data/providers.dart' show settingsRepositoryProvider;
import '../data/interval_levels.dart';
import '../data/providers.dart';
import '../domain/interval_direction.dart';
import '../domain/interval_type.dart';
import 'ear_training_screen.dart';

class EarTrainerHomeScreen extends ConsumerWidget {
  const EarTrainerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final level = ref.watch(earLevelProvider);
    final direction = ref.watch(earDirectionProvider);
    final customMode = ref.watch(earCustomModeProvider);
    final customPool = ref.watch(earCustomPoolProvider);

    final activePool =
        customMode ? customPool.toList() : getIntervalsForLevel(level);
    final canStart = activePool.length >= 2;

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
                    l10n.menuEarTrainer,
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                children: [
                  // Direction
                  Text(l10n.earTrainerDirection,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  _DirectionSelector(
                    value: direction,
                    onChanged: (d) {
                      ref.read(earDirectionProvider.notifier).update(d);
                      repo.saveEarDirection(d.index);
                    },
                    l10n: l10n,
                  ),
                  const SizedBox(height: 28),

                  // Level vs Custom toggle
                  Row(
                    children: [
                      Text(l10n.level, style: theme.textTheme.titleMedium),
                      const Spacer(),
                      _ModeToggle(
                        customMode: customMode,
                        onToggle: (v) {
                          ref.read(earCustomModeProvider.notifier).update(v);
                          repo.saveEarCustomMode(v);
                        },
                        l10n: l10n,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (!customMode) ...[
                    _LevelStepper(
                      level: level,
                      onChanged: (v) {
                        ref.read(earLevelProvider.notifier).update(v);
                        repo.saveEarLevel(v);
                      },
                      theme: theme,
                      pool: getIntervalsForLevel(level),
                    ),
                  ] else ...[
                    _CustomPoolSelector(
                      pool: customPool,
                      onChanged: (pool) {
                        ref.read(earCustomPoolProvider.notifier).update(pool);
                        repo.saveEarCustomPool(
                            pool.map((t) => t.index).toList());
                      },
                      theme: theme,
                    ),
                    if (!canStart)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          l10n.earTrainerSelectAtLeastTwo,
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: canStart
                          ? () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => EarTrainingScreen(
                                    pool: activePool,
                                    direction: direction,
                                  ),
                                ),
                              )
                          : null,
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

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _DirectionSelector extends StatelessWidget {
  const _DirectionSelector({
    required this.value,
    required this.onChanged,
    required this.l10n,
  });

  final IntervalDirection value;
  final void Function(IntervalDirection) onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: IntervalDirection.values.map((d) {
        return FilterChip(
          label: Text(_directionLabel(d, l10n)),
          selected: value == d,
          onSelected: (_) => onChanged(d),
        );
      }).toList(),
    );
  }

  String _directionLabel(IntervalDirection d, AppLocalizations l10n) =>
      switch (d) {
        IntervalDirection.ascending => l10n.earTrainerAscending,
        IntervalDirection.descending => l10n.earTrainerDescending,
        IntervalDirection.harmonic => l10n.earTrainerHarmonic,
        IntervalDirection.random => l10n.earTrainerRandom,
      };
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({
    required this.customMode,
    required this.onToggle,
    required this.l10n,
  });

  final bool customMode;
  final void Function(bool) onToggle;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.earTrainerCustom,
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(width: 8),
        Switch(value: customMode, onChanged: onToggle),
      ],
    );
  }
}

class _LevelStepper extends StatelessWidget {
  const _LevelStepper({
    required this.level,
    required this.onChanged,
    required this.theme,
    required this.pool,
  });

  final int level;
  final void Function(int) onChanged;
  final ThemeData theme;
  final List<IntervalType> pool;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.outlined(
          icon: const Icon(Icons.remove),
          onPressed: level > 1 ? () => onChanged(level - 1) : null,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Level $level',
                style: theme.textTheme.titleLarge
                    ?.copyWith(color: theme.colorScheme.primary),
                textAlign: TextAlign.center,
              ),
              Text(
                pool.map((t) => t.shortLabel).join('  '),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(160),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        IconButton.outlined(
          icon: const Icon(Icons.add),
          onPressed:
              level < kEarTrainerLevelCount ? () => onChanged(level + 1) : null,
        ),
      ],
    );
  }
}

class _CustomPoolSelector extends StatelessWidget {
  const _CustomPoolSelector({
    required this.pool,
    required this.onChanged,
    required this.theme,
  });

  final Set<IntervalType> pool;
  final void Function(Set<IntervalType>) onChanged;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: IntervalType.values.map((t) {
        final selected = pool.contains(t);
        return FilterChip(
          label: Text(t.shortLabel),
          selected: selected,
          onSelected: (v) {
            final next = Set<IntervalType>.from(pool);
            if (v) {
              next.add(t);
            } else if (next.length > 1) {
              next.remove(t);
            }
            onChanged(next);
          },
        );
      }).toList(),
    );
  }
}
