import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/arpeggio_inversion.dart';

String arpeggioInversionName(
  ArpeggioInversion inversion,
  AppLocalizations l10n,
) =>
    switch (inversion) {
      ArpeggioInversion.root => l10n.arpeggioRootPosition,
      ArpeggioInversion.first => l10n.arpeggioFirstInversion,
      ArpeggioInversion.second => l10n.arpeggioSecondInversion,
      ArpeggioInversion.random => l10n.arpeggioRandomInversion,
    };

/// Names the inversion a single round runs in, where 1 is the first inversion.
/// Third inversions only turn up under [ArpeggioInversion.random].
String arpeggioInversionLabel(int inversion, AppLocalizations l10n) =>
    switch (inversion) {
      1 => l10n.arpeggioFirstInversion,
      2 => l10n.arpeggioSecondInversion,
      _ => l10n.arpeggioThirdInversion,
    };
