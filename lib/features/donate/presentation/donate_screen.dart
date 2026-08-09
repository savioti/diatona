import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../data/donate_links.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  Future<void> _open(BuildContext context, String url) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.donateLinkError)));
    }
  }

  Future<void> _copyPix(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(const ClipboardData(text: donatePixKey));
    messenger.showSnackBar(SnackBar(content: Text(l10n.donatePixCopied)));
  }

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
                    l10n.menuDonate,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: Text(
                      l10n.donateIntro,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet_outlined),
                    title: const Text('PayPal'),
                    trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                    onTap: () => _open(context, donatePayPalUrl),
                  ),
                  ListTile(
                    leading: const Icon(Icons.coffee_outlined),
                    title: const Text('Buy Me a Coffee'),
                    trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                    onTap: () => _open(context, donateBuyMeACoffeeUrl),
                  ),
                  ListTile(
                    leading: const Icon(Icons.pix),
                    title: const Text('PIX'),
                    subtitle: Text(
                      donatePixKey,
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: const Icon(Icons.copy_rounded, size: 20),
                    onTap: () => _copyPix(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Text(
                      l10n.donateThanks,
                      style: theme.textTheme.bodySmall,
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
