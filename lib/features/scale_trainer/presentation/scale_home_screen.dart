import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/sequence_trainer/domain/sequence_direction.dart';
import '../../../core/sequence_trainer/presentation/sequence_labels.dart';
import '../../../core/sequence_trainer/presentation/sequence_training_screen.dart';
import '../../../core/sequence_trainer/presentation/widgets/training_options.dart';
import '../../home/presentation/widgets/interval_selector.dart';
import '../../trainer/data/providers.dart' show settingsRepositoryProvider;
import '../data/providers.dart';
import '../data/scale_data.dart';
import '../domain/scale_type.dart';
import 'scale_labels.dart';

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

    void start() {
      String title(ScaleType type, String root) =>
          l10n.trainingRootLabel(root, scaleTypeName(type, l10n));

      final pool = cumulative
          ? buildScalePool(level, direction,
              title: title, naturalRootsOnly: naturalRoots)
          : buildScalePoolSingle(level, direction,
              title: title, naturalRootsOnly: naturalRoots);

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SequenceTrainingScreen(
            pool: pool,
            headline: scaleTypeNameForLevel(level, l10n),
            subtitle: '${sequenceDirectionName(direction, l10n)} · '
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
                  SetupLabel(l10n.level),
                  const SizedBox(height: 8),
                  Text(
                    l10n.levelLabel(level, scaleTypeNameForLevel(level, l10n)),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  LevelStepper(
                    level: level,
                    maxLevel: ScaleType.values.length,
                    onChanged: (v) {
                      ref.read(selectedScaleLevelProvider.notifier).update(v);
                      repo.saveScaleLevel(v);
                    },
                  ),
                  const SizedBox(height: 8),
                  OptionCheckbox(
                    value: cumulative,
                    label: l10n.cumulativePool,
                    helpTitle: l10n.cumulativePoolHelpTitle,
                    helpBody: l10n.cumulativePoolHelpBody,
                    onChanged: (v) {
                      ref
                          .read(selectedScaleCumulativeProvider.notifier)
                          .update(v);
                      repo.saveScaleCumulative(v);
                    },
                  ),
                  const SizedBox(height: 24),
                  SetupLabel(l10n.trainingDirection),
                  const SizedBox(height: 12),
                  ChoiceChipRow<SequenceDirection>(
                    values: SequenceDirection.values,
                    selected: direction,
                    labelOf: (d) => sequenceDirectionName(d, l10n),
                    onChanged: (d) {
                      ref
                          .read(selectedScaleDirectionProvider.notifier)
                          .update(d);
                      repo.saveScaleDirection(d.index);
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
                          .read(selectedScaleNaturalRootsProvider.notifier)
                          .update(v);
                      repo.saveScaleNaturalRoots(v);
                    },
                  ),
                  const SizedBox(height: 20),
                  OptionCheckbox(
                    value: showNotes,
                    label: l10n.trainingShowNotes,
                    helpTitle: l10n.trainingShowNotesHelpTitle,
                    helpBody: l10n.trainingShowNotesHelpBody,
                    onChanged: (v) {
                      ref
                          .read(selectedScaleShowNotesProvider.notifier)
                          .update(v);
                      repo.saveScaleShowNotes(v);
                    },
                  ),
                  const SizedBox(height: 24),
                  SetupLabel(l10n.timeLimit),
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
                      onPressed: start,
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
