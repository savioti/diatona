import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../home/presentation/widgets/interval_selector.dart';
import '../../trainer/data/providers.dart';
import '../data/providers.dart';
import '../domain/note_clef.dart';
import 'note_training_screen.dart';

class NoteHomeScreen extends ConsumerWidget {
  const NoteHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final clef = ref.watch(selectedNoteClefProvider);
    final interval = ref.watch(selectedNoteIntervalProvider);
    final level = ref.watch(selectedNoteLevelProvider);
    final cumulative = ref.watch(selectedNoteCumulativeProvider);
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
                l10n.menuNoteTrainer,
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
              _LevelSelector(
                selectedLevel: level,
                onLevelChanged: (v) {
                  ref.read(selectedNoteLevelProvider.notifier).update(v);
                  repo.saveNoteLevel(v);
                },
                l10n: l10n,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: cumulative,
                    onChanged: (v) {
                      final next = v ?? true;
                      ref
                          .read(selectedNoteCumulativeProvider.notifier)
                          .update(next);
                      repo.saveNoteCumulative(next);
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
                l10n.noteTrainerDisplayModeLabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _ClefSelector(
                selectedClef: clef,
                onClefChanged: (c) {
                  ref.read(selectedNoteClefProvider.notifier).update(c);
                  repo.saveNoteClef(c.index);
                },
              ),
              const SizedBox(height: 24),
              Text(
                l10n.timeLimit,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              IntervalSelector(
                selectedInterval: interval,
                onIntervalChanged: (v) {
                  ref.read(selectedNoteIntervalProvider.notifier).update(v);
                  repo.saveNoteInterval(v);
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => NoteTrainingScreen(
                        timeLimitSeconds: interval,
                        clef: clef,
                        level: level,
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

  String _levelName(int level, AppLocalizations l10n) => switch (level) {
        1 => l10n.noteLevelStandard,
        _ => l10n.noteLevelAccidentals,
      };
}

class _LevelSelector extends StatelessWidget {
  const _LevelSelector({
    required this.selectedLevel,
    required this.onLevelChanged,
    required this.l10n,
  });

  final int selectedLevel;
  final ValueChanged<int> onLevelChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final levels = {1: l10n.noteLevelStandard, 2: l10n.noteLevelAccidentals};

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: levels.entries.map((e) {
        final selected = e.key == selectedLevel;
        return FilterChip(
          label: Text(
            e.value,
            style: TextStyle(
              color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
          selected: selected,
          onSelected: (_) => onLevelChanged(e.key),
        );
      }).toList(),
    );
  }
}

class _ClefSelector extends StatelessWidget {
  const _ClefSelector({
    required this.selectedClef,
    required this.onClefChanged,
  });

  final NoteClef selectedClef;
  final ValueChanged<NoteClef> onClefChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    String label(NoteClef c) => switch (c) {
          NoteClef.trebleClef => l10n.displayModeTrebleClef,
          NoteClef.bassClef => l10n.displayModeBassClef,
          NoteClef.letterNames => l10n.displayModeLetterNames,
        };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: NoteClef.values.map((c) {
        final selected = c == selectedClef;
        return FilterChip(
          label: Text(
            label(c),
            style: TextStyle(
              color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
          selected: selected,
          onSelected: (_) => onClefChanged(c),
        );
      }).toList(),
    );
  }
}
