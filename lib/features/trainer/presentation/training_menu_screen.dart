import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../home/presentation/home_screen.dart';
import '../../main_menu/presentation/widgets/feature_card.dart';
import '../../note_trainer/presentation/note_home_screen.dart';

class TrainingMenuScreen extends StatelessWidget {
  const TrainingMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

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
                l10n.menuTraining,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    FeatureCard(
                      icon: Icons.music_note_rounded,
                      label: l10n.menuNoteTrainer,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const NoteHomeScreen(),
                        ),
                      ),
                    ),
                    FeatureCard(
                      icon: Icons.piano_rounded,
                      label: l10n.menuChordTraining,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const HomeScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
