import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/harmony/data/progression_data.dart';
import '../../../core/harmony/presentation/harmony_labels.dart';
import '../../../core/harmony/presentation/widgets/progression_picker.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/sequence_trainer/presentation/sequence_labels.dart';
import '../../../core/sequence_trainer/presentation/sequence_training_screen.dart';
import '../../../core/sequence_trainer/presentation/widgets/training_options.dart';
import '../../home/presentation/widgets/interval_selector.dart';
import '../../trainer/data/providers.dart' show settingsRepositoryProvider;
import '../data/progression_pool.dart';
import '../data/providers.dart';

class ProgressionHomeScreen extends ConsumerWidget {
  const ProgressionHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final selected = ref.watch(selectedProgPoolProvider);
    final naturalRoots = ref.watch(selectedProgNaturalRootsProvider);
    final interval = ref.watch(selectedProgIntervalProvider);
    final showNotes = ref.watch(selectedProgShowNotesProvider);
    final arpeggiate = ref.watch(selectedProgArpeggiateProvider);
    final repo = ref.read(settingsRepositoryProvider);

    final progressions =
        progressionData.where((p) => selected.contains(p.id)).toList();

    void start() {
      final pool = buildProgressionPool(
        progressions,
        keyLabel: (key) => harmonicKeyName(key, l10n),
        naturalRootsOnly: naturalRoots,
        arpeggiate: arpeggiate,
      );

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SequenceTrainingScreen(
            pool: pool,
            headline: l10n.menuProgressionTrainer,
            subtitle: trainingKeysName(naturalRoots, l10n),
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
                    l10n.menuProgressionTrainer,
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
                  SetupLabel(l10n.progressionPool),
                  const SizedBox(height: 4),
                  Text(
                    l10n.progressionTrainerHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(160),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ProgressionPicker(
                    selected: selected,
                    onChanged: (pool) {
                      ref.read(selectedProgPoolProvider.notifier).update(pool);
                      repo.saveProgPool(pool.toList());
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
                          .read(selectedProgNaturalRootsProvider.notifier)
                          .update(v);
                      repo.saveProgNaturalRoots(v);
                    },
                  ),
                  const SizedBox(height: 20),
                  OptionCheckbox(
                    value: arpeggiate,
                    label: l10n.progressionArpeggiate,
                    helpTitle: l10n.progressionArpeggiateHelpTitle,
                    helpBody: l10n.progressionArpeggiateHelpBody,
                    onChanged: (v) {
                      ref
                          .read(selectedProgArpeggiateProvider.notifier)
                          .update(v);
                      repo.saveProgArpeggiate(v);
                    },
                  ),
                  OptionCheckbox(
                    value: showNotes,
                    label: l10n.trainingShowNotes,
                    helpTitle: l10n.trainingShowNotesHelpTitle,
                    helpBody: l10n.trainingShowNotesHelpBody,
                    onChanged: (v) {
                      ref
                          .read(selectedProgShowNotesProvider.notifier)
                          .update(v);
                      repo.saveProgShowNotes(v);
                    },
                  ),
                  const SizedBox(height: 24),
                  SetupLabel(l10n.timeLimit),
                  const SizedBox(height: 12),
                  IntervalSelector(
                    selectedInterval: interval,
                    onIntervalChanged: (v) {
                      ref
                          .read(selectedProgIntervalProvider.notifier)
                          .update(v);
                      repo.saveProgInterval(v);
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: progressions.isEmpty ? null : start,
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
