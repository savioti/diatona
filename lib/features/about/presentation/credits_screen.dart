import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../data/credits_data.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
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
                    l10n.menuCredits,
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
                children: [
                  for (final credit in credits)
                    ListTile(
                      title: Text(credit.name),
                      subtitle: Text(credit.role),
                    ),
                  const Divider(height: 32),
                  ListTile(
                    title: Text(l10n.creditsOpenSourceLicenses),
                    subtitle: Text(l10n.creditsOpenSourceLicensesSubtitle),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: 'Diatona',
                      applicationLegalese: '© 2026 Angelo Savioti',
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
