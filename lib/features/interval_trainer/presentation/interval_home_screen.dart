import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/sequence_trainer/domain/sequence_direction.dart';
import '../../../core/sequence_trainer/presentation/sequence_labels.dart';
import '../../../core/sequence_trainer/presentation/sequence_training_screen.dart';
import '../../../core/sequence_trainer/presentation/widgets/training_options.dart';
import '../../ear_trainer/data/interval_levels.dart';
import '../../ear_trainer/domain/interval_type.dart';
import '../../ear_trainer/presentation/interval_labels.dart';
import '../../home/presentation/widgets/interval_selector.dart';
import '../../trainer/data/providers.dart' show settingsRepositoryProvider;
import '../data/interval_pool.dart';
import '../data/providers.dart';

class IntervalHomeScreen extends ConsumerWidget {
  const IntervalHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final level = ref.watch(selectedIntLevelProvider);
    final customMode = ref.watch(selectedIntCustomModeProvider);
    final customPool = ref.watch(selectedIntCustomPoolProvider);
    final direction = ref.watch(selectedIntDirectionProvider);
    final naturalRoots = ref.watch(selectedIntNaturalRootsProvider);
    final interval = ref.watch(selectedIntIntervalProvider);
    final showNotes = ref.watch(selectedIntShowNotesProvider);
    final playRoot = ref.watch(selectedIntPlayRootProvider);
    final repo = ref.read(settingsRepositoryProvider);

    final types = customMode
        ? playableIntervals.where(customPool.contains).toList()
        : intervalsForLevel(level);

    void start() {
      final pool = buildIntervalPool(
        types,
        direction,
        title: (type, root) =>
            l10n.trainingRootLabel(root, intervalTypeName(type, l10n)),
        directionLabel: (descending) => descending
            ? l10n.trainingDescending
            : l10n.trainingAscending,
        naturalRootsOnly: naturalRoots,
        playRoot: playRoot,
      );

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SequenceTrainingScreen(
            pool: pool,
            headline: customMode
                ? l10n.trainingCustom
                : l10n.levelLabel(level, _levelSummary(types)),
            subtitle: '${_directionName(direction, l10n)} · '
                '${trainingKeysName(naturalRoots, l10n)}',
            timeLimitSeconds: interval,
            showNames: showNotes,
          ),
        ),
      );
    }

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
                    l10n.menuIntervalTrainer,
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
                  Row(
                    children: [
                      SetupLabel(l10n.level),
                      const Spacer(),
                      Text(
                        l10n.trainingCustom,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: customMode,
                        onChanged: (v) {
                          ref
                              .read(selectedIntCustomModeProvider.notifier)
                              .update(v);
                          repo.saveIntCustomMode(v);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (customMode)
                    MultiChoiceChipRow<IntervalType>(
                      values: playableIntervals,
                      selected: customPool,
                      labelOf: (t) => t.shortLabel,
                      onChanged: (pool) {
                        ref
                            .read(selectedIntCustomPoolProvider.notifier)
                            .update(pool);
                        repo.saveIntCustomPool(
                            pool.map((t) => t.index).toList());
                      },
                    )
                  else ...[
                    Text(
                      l10n.levelLabel(level, _levelSummary(types)),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    LevelStepper(
                      level: level,
                      maxLevel: kEarTrainerLevelCount,
                      onChanged: (v) {
                        ref.read(selectedIntLevelProvider.notifier).update(v);
                        repo.saveIntLevel(v);
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  SetupLabel(l10n.trainingDirection),
                  const SizedBox(height: 12),
                  ChoiceChipRow<SequenceDirection>(
                    values: SequenceDirection.values,
                    selected: direction,
                    labelOf: (d) => _directionName(d, l10n),
                    onChanged: (d) {
                      ref
                          .read(selectedIntDirectionProvider.notifier)
                          .update(d);
                      repo.saveIntDirection(d.index);
                    },
                  ),
                  const SizedBox(height: 24),
                  SetupLabel(l10n.trainingKeys),
                  const SizedBox(height: 12),
                  ChoiceChipRow<bool>(
                    values: const [true, false],
                    selected: naturalRoots,
                    labelOf: (v) => trainingKeysName(v, l10n),
                    onChanged: (v) {
                      ref
                          .read(selectedIntNaturalRootsProvider.notifier)
                          .update(v);
                      repo.saveIntNaturalRoots(v);
                    },
                  ),
                  const SizedBox(height: 20),
                  OptionCheckbox(
                    value: playRoot,
                    label: l10n.intervalPlayRoot,
                    helpTitle: l10n.intervalPlayRootHelpTitle,
                    helpBody: l10n.intervalPlayRootHelpBody,
                    onChanged: (v) {
                      ref
                          .read(selectedIntPlayRootProvider.notifier)
                          .update(v);
                      repo.saveIntPlayRoot(v);
                    },
                  ),
                  OptionCheckbox(
                    value: showNotes,
                    label: l10n.trainingShowNotes,
                    helpTitle: l10n.trainingShowNotesHelpTitle,
                    helpBody: l10n.trainingShowNotesHelpBody,
                    onChanged: (v) {
                      ref
                          .read(selectedIntShowNotesProvider.notifier)
                          .update(v);
                      repo.saveIntShowNotes(v);
                    },
                  ),
                  const SizedBox(height: 24),
                  SetupLabel(l10n.timeLimit),
                  const SizedBox(height: 12),
                  IntervalSelector(
                    selectedInterval: interval,
                    onIntervalChanged: (v) {
                      ref.read(selectedIntIntervalProvider.notifier).update(v);
                      repo.saveIntInterval(v);
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: types.isEmpty ? null : start,
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

  /// Levels have no name of their own, so they are named by what they hold.
  String _levelSummary(List<IntervalType> types) =>
      types.map((t) => t.shortLabel).join(' ');
}

/// Mixed rather than up and down: an interval round runs in one direction, the
/// pool is what holds both.
String _directionName(SequenceDirection direction, AppLocalizations l10n) =>
    direction == SequenceDirection.upAndDown
        ? l10n.trainingMixed
        : sequenceDirectionName(direction, l10n);
