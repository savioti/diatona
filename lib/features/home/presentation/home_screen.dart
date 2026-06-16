import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../trainer/data/providers.dart';
import '../../trainer/domain/chord_type.dart';
import '../../trainer/presentation/training_screen.dart';
import 'widgets/display_mode_selector.dart';
import 'widgets/interval_selector.dart';
import 'widgets/level_selector.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final level = ref.watch(selectedLevelProvider);
    final interval = ref.watch(selectedIntervalProvider);
    final cumulative = ref.watch(selectedCumulativeProvider);
    final displayMode = ref.watch(selectedDisplayModeProvider);
    final repo = ref.read(settingsRepositoryProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                l10n.homeTitle,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 48),
              Text(l10n.level, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                l10n.levelLabel(level, _levelName(level, l10n)),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              LevelSelector(
                selectedLevel: level,
                onLevelChanged: (newLevel) {
                  ref.read(selectedLevelProvider.notifier).update(newLevel);
                  repo.saveLevel(newLevel);
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: cumulative,
                    onChanged: (value) {
                      final v = value ?? true;
                      ref.read(selectedCumulativeProvider.notifier).update(v);
                      repo.saveCumulative(v);
                    },
                  ),
                  Text(
                    l10n.cumulativePool,
                    style: Theme.of(context).textTheme.bodyMedium,
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
              Text(
                l10n.timeLimit,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              IntervalSelector(
                selectedInterval: interval,
                onIntervalChanged: (newInterval) {
                  ref
                      .read(selectedIntervalProvider.notifier)
                      .update(newInterval);
                  repo.saveInterval(newInterval);
                },
              ),
              const SizedBox(height: 24),
              Text(
                l10n.chordDisplay,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              DisplayModeSelector(
                selectedMode: displayMode,
                onModeChanged: (mode) {
                  ref.read(selectedDisplayModeProvider.notifier).update(mode);
                  repo.saveDisplayMode(mode.index);
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => TrainingScreen(
                        level: level,
                        timeLimitSeconds: interval,
                        cumulative: cumulative,
                      ),
                    ),
                  );
                },
                child: Text(l10n.start),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _levelName(int level, AppLocalizations l10n) {
    final type =
        ChordType.values[(level - 1).clamp(0, ChordType.values.length - 1)];
    return switch (type) {
      ChordType.major => l10n.levelMajor,
      ChordType.minor => l10n.levelMinor,
      ChordType.aug => l10n.levelAug,
      ChordType.dim => l10n.levelDim,
      ChordType.sus => l10n.levelSus,
      ChordType.seventh => l10n.levelSeventh,
      ChordType.maj7 => l10n.levelMaj7,
      ChordType.m7 => l10n.levelM7,
      ChordType.dim7 => l10n.levelDim7,
      ChordType.halfDim7 => l10n.levelHalfDim7,
      ChordType.mMaj7 => l10n.levelMMaj7,
      ChordType.augMaj7 => l10n.levelAugMaj7,
    };
  }
}
