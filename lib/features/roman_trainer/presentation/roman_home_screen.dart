import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/sequence_trainer/presentation/sequence_labels.dart';
import '../../../core/sequence_trainer/presentation/widgets/training_options.dart';
import '../../scale_trainer/domain/scale_type.dart';
import '../../scale_trainer/presentation/scale_labels.dart';
import '../../trainer/data/providers.dart' show settingsRepositoryProvider;
import '../data/providers.dart';
import '../data/roman_questions.dart';
import '../domain/roman_question.dart';
import 'roman_labels.dart';
import 'roman_training_screen.dart';

class RomanHomeScreen extends ConsumerWidget {
  const RomanHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final scales = ref.watch(selectedRnScalesProvider);
    final mode = ref.watch(selectedRnModeProvider);
    final sevenths = ref.watch(selectedRnSeventhsProvider);
    final naturalRoots = ref.watch(selectedRnNaturalRootsProvider);
    final hearChord = ref.watch(selectedRnHearChordProvider);
    final repo = ref.read(settingsRepositoryProvider);

    void start() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => RomanTrainingScreen(
            config: RomanDrillConfig(
              scales: ScaleType.values.where(scales.contains).toList(),
              mode: mode,
              sevenths: sevenths,
              naturalRootsOnly: naturalRoots,
              hearChord: hearChord,
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
                    l10n.menuRomanTrainer,
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
                  SetupLabel(l10n.romanDirection),
                  const SizedBox(height: 12),
                  ChoiceChipRow<RomanDrillMode>(
                    values: RomanDrillMode.values,
                    selected: mode,
                    labelOf: (m) => romanDrillModeName(m, l10n),
                    onChanged: (m) {
                      ref.read(selectedRnModeProvider.notifier).update(m);
                      repo.saveRnMode(m.index);
                    },
                  ),
                  const SizedBox(height: 24),
                  SetupLabel(l10n.romanScales),
                  const SizedBox(height: 12),
                  MultiChoiceChipRow<ScaleType>(
                    values: ScaleType.values,
                    selected: scales,
                    labelOf: (s) => scaleTypeName(s, l10n),
                    onChanged: (next) {
                      ref.read(selectedRnScalesProvider.notifier).update(next);
                      repo.saveRnScales(
                          next.map((s) => s.index).toList());
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
                          .read(selectedRnNaturalRootsProvider.notifier)
                          .update(v);
                      repo.saveRnNaturalRoots(v);
                    },
                  ),
                  const SizedBox(height: 20),
                  OptionCheckbox(
                    value: sevenths,
                    label: l10n.romanSevenths,
                    helpTitle: l10n.romanSeventhsHelpTitle,
                    helpBody: l10n.romanSeventhsHelpBody,
                    onChanged: (v) {
                      ref
                          .read(selectedRnSeventhsProvider.notifier)
                          .update(v);
                      repo.saveRnSevenths(v);
                    },
                  ),
                  OptionCheckbox(
                    value: hearChord,
                    label: l10n.romanHearChord,
                    helpTitle: l10n.romanHearChordHelpTitle,
                    helpBody: l10n.romanHearChordHelpBody,
                    onChanged: (v) {
                      ref
                          .read(selectedRnHearChordProvider.notifier)
                          .update(v);
                      repo.saveRnHearChord(v);
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: scales.isEmpty ? null : start,
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
