import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/scale_type.dart';

String scaleTypeName(ScaleType type, AppLocalizations l10n) => switch (type) {
      ScaleType.major => l10n.scaleMajor,
      ScaleType.naturalMinor => l10n.scaleNaturalMinor,
      ScaleType.dorian => l10n.scaleDorian,
      ScaleType.mixolydian => l10n.scaleMixolydian,
      ScaleType.lydian => l10n.scaleLydian,
      ScaleType.phrygian => l10n.scalePhrygian,
      ScaleType.locrian => l10n.scaleLocrian,
      ScaleType.harmonicMinor => l10n.scaleHarmonicMinor,
      ScaleType.melodicMinor => l10n.scaleMelodicMinor,
    };

String scaleTypeNameForLevel(int level, AppLocalizations l10n) => scaleTypeName(
      ScaleType.values[(level - 1).clamp(0, ScaleType.values.length - 1)],
      l10n,
    );
