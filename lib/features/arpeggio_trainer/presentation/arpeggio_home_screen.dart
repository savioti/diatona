import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/sequence_trainer/domain/sequence_direction.dart';
import '../../../core/sequence_trainer/presentation/sequence_labels.dart';
import '../../../core/sequence_trainer/presentation/sequence_training_screen.dart';
import '../../../core/sequence_trainer/presentation/widgets/training_options.dart';
import '../../home/presentation/widgets/interval_selector.dart';
import '../../trainer/data/providers.dart' show settingsRepositoryProvider;
import '../../trainer/domain/chord_type.dart';
import '../../trainer/presentation/chord_labels.dart';
import '../data/arpeggio_data.dart';
import '../data/providers.dart';
import '../domain/arpeggio_inversion.dart';
import 'arpeggio_labels.dart';

class ArpeggioHomeScreen extends ConsumerWidget {
  const ArpeggioHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final level = ref.watch(selectedArpLevelProvider);
    final cumulative = ref.watch(selectedArpCumulativeProvider);
    final direction = ref.watch(selectedArpDirectionProvider);
    final naturalRoots = ref.watch(selectedArpNaturalRootsProvider);
    final inversion = ref.watch(selectedArpInversionProvider);
    final octaves = ref.watch(selectedArpOctavesProvider);
    final interval = ref.watch(selectedArpIntervalProvider);
    final showNotes = ref.watch(selectedArpShowNotesProvider);
    final repo = ref.read(settingsRepositoryProvider);

    void start() {
      String label(int index) => arpeggioInversionLabel(index, l10n);

      final pool = cumulative
          ? buildArpeggioPool(level, direction,
              inversion: inversion,
              octaves: octaves,
              inversionLabel: label,
              naturalRootsOnly: naturalRoots)
          : buildArpeggioPoolSingle(level, direction,
              inversion: inversion,
              octaves: octaves,
              inversionLabel: label,
              naturalRootsOnly: naturalRoots);

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SequenceTrainingScreen(
            pool: pool,
            headline: chordTypeNameForLevel(level, l10n),
            subtitle: '${sequenceDirectionName(direction, l10n)} · '
                '${arpeggioInversionName(inversion, l10n)}',
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
                    l10n.menuArpeggioTrainer,
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
                    l10n.levelLabel(level, chordTypeNameForLevel(level, l10n)),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  LevelStepper(
                    level: level,
                    maxLevel: ChordType.values.length,
                    onChanged: (v) {
                      ref.read(selectedArpLevelProvider.notifier).update(v);
                      repo.saveArpLevel(v);
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
                          .read(selectedArpCumulativeProvider.notifier)
                          .update(v);
                      repo.saveArpCumulative(v);
                    },
                  ),
                  const SizedBox(height: 24),
                  SetupLabel(l10n.arpeggioInversion),
                  const SizedBox(height: 12),
                  ChoiceChipRow<ArpeggioInversion>(
                    values: ArpeggioInversion.values,
                    selected: inversion,
                    labelOf: (i) => arpeggioInversionName(i, l10n),
                    onChanged: (i) {
                      ref
                          .read(selectedArpInversionProvider.notifier)
                          .update(i);
                      repo.saveArpInversion(i.index);
                    },
                  ),
                  const SizedBox(height: 24),
                  SetupLabel(l10n.arpeggioOctaves),
                  const SizedBox(height: 12),
                  ChoiceChipRow<int>(
                    values: const [1, 2],
                    selected: octaves,
                    labelOf: (v) => '$v',
                    onChanged: (v) {
                      ref.read(selectedArpOctavesProvider.notifier).update(v);
                      repo.saveArpOctaves(v);
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
                          .read(selectedArpDirectionProvider.notifier)
                          .update(d);
                      repo.saveArpDirection(d.index);
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
                          .read(selectedArpNaturalRootsProvider.notifier)
                          .update(v);
                      repo.saveArpNaturalRoots(v);
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
                          .read(selectedArpShowNotesProvider.notifier)
                          .update(v);
                      repo.saveArpShowNotes(v);
                    },
                  ),
                  const SizedBox(height: 24),
                  SetupLabel(l10n.timeLimit),
                  const SizedBox(height: 12),
                  IntervalSelector(
                    selectedInterval: interval,
                    onIntervalChanged: (v) {
                      ref.read(selectedArpIntervalProvider.notifier).update(v);
                      repo.saveArpInterval(v);
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
