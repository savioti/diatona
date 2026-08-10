import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/harmony/data/progression_data.dart';
import '../../../core/harmony/domain/progression_tempo.dart';
import '../../../core/harmony/presentation/harmony_labels.dart';
import '../../../core/harmony/presentation/widgets/progression_picker.dart';
import '../../../core/harmony_ear/presentation/harmony_ear_provider.dart';
import '../../../core/harmony_ear/presentation/harmony_ear_screen.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/sequence_trainer/presentation/sequence_labels.dart';
import '../../../core/sequence_trainer/presentation/widgets/training_options.dart';
import '../../trainer/data/providers.dart' show settingsRepositoryProvider;
import '../data/progression_questions.dart';
import '../data/providers.dart';

class ProgressionEarHomeScreen extends ConsumerWidget {
  const ProgressionEarHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final selected = ref.watch(selectedPearPoolProvider);
    final tempo = ref.watch(selectedPearTempoProvider);
    final arpeggiate = ref.watch(selectedPearArpeggiateProvider);
    final naturalRoots = ref.watch(selectedPearNaturalRootsProvider);
    final repo = ref.read(settingsRepositoryProvider);

    final pool =
        progressionData.where((p) => selected.contains(p.id)).toList();
    final canStart = pool.length >= 2;

    void start() {
      final random = Random();
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => HarmonyEarScreen(
            prompt: l10n.progressionEarWhich,
            config: HarmonyEarConfig(
              choices: progressionChoices(pool),
              millisPerChord: tempo.millis,
              arpeggiate: arpeggiate,
              nextQuestion: (previous) => buildProgressionQuestion(
                pool,
                random,
                naturalRootsOnly: naturalRoots,
                keyLabel: (key) => harmonicKeyName(key, l10n),
                previous: previous,
              ),
            ),
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
                    l10n.menuProgressionEarTrainer,
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
                    l10n.progressionEarHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(160),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ProgressionPicker(
                    selected: selected,
                    minSelected: 2,
                    onChanged: (next) {
                      ref.read(selectedPearPoolProvider.notifier).update(next);
                      repo.savePearPool(next.toList());
                    },
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
                  const SizedBox(height: 24),
                  SetupLabel(l10n.progressionTempo),
                  const SizedBox(height: 12),
                  ChoiceChipRow<ProgressionTempo>(
                    values: ProgressionTempo.values,
                    selected: tempo,
                    labelOf: (t) => progressionTempoName(t, l10n),
                    onChanged: (t) {
                      ref.read(selectedPearTempoProvider.notifier).update(t);
                      repo.savePearTempo(t.index);
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
                          .read(selectedPearNaturalRootsProvider.notifier)
                          .update(v);
                      repo.savePearNaturalRoots(v);
                    },
                  ),
                  const SizedBox(height: 20),
                  OptionCheckbox(
                    value: arpeggiate,
                    label: l10n.refProgressionsArpeggiate,
                    helpTitle: l10n.progressionArpeggiatePlaybackHelpTitle,
                    helpBody: l10n.progressionArpeggiatePlaybackHelpBody,
                    onChanged: (v) {
                      ref
                          .read(selectedPearArpeggiateProvider.notifier)
                          .update(v);
                      repo.savePearArpeggiate(v);
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: canStart ? start : null,
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
