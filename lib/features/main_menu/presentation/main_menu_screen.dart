import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../references/presentation/references_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../trainer/presentation/training_menu_screen.dart';
import 'widgets/feature_card.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset('assets/logo/logo.png', height: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.appTitle,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 32,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: l10n.settings,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    FeatureCard(
                      icon: Icons.fitness_center_rounded,
                      label: l10n.menuTraining,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const TrainingMenuScreen(),
                        ),
                      ),
                    ),
                    FeatureCard(
                      icon: Icons.school_rounded,
                      label: l10n.menuLearning,
                      comingSoon: true,
                    ),
                    FeatureCard(
                      icon: Icons.tune_rounded,
                      label: l10n.menuTools,
                      comingSoon: true,
                    ),
                    FeatureCard(
                      icon: Icons.menu_book_rounded,
                      label: l10n.menuReference,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ReferencesScreen(),
                        ),
                      ),
                    ),
                    FeatureCard(
                      icon: Icons.favorite_rounded,
                      label: l10n.menuDonate,
                      comingSoon: true,
                    ),
                    FeatureCard(
                      icon: Icons.info_outline_rounded,
                      label: l10n.menuAbout,
                      comingSoon: true,
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
