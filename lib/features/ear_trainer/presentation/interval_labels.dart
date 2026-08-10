import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/interval_type.dart';

String intervalTypeName(IntervalType type, AppLocalizations l10n) =>
    switch (type) {
      IntervalType.minSecond => l10n.intervalMinSecond,
      IntervalType.majSecond => l10n.intervalMajSecond,
      IntervalType.minThird => l10n.intervalMinThird,
      IntervalType.majThird => l10n.intervalMajThird,
      IntervalType.perfectFourth => l10n.intervalPerfectFourth,
      IntervalType.tritone => l10n.intervalTritone,
      IntervalType.perfectFifth => l10n.intervalPerfectFifth,
      IntervalType.minSixth => l10n.intervalMinSixth,
      IntervalType.majSixth => l10n.intervalMajSixth,
      IntervalType.minSeventh => l10n.intervalMinSeventh,
      IntervalType.majSeventh => l10n.intervalMajSeventh,
      IntervalType.octave => l10n.intervalOctave,
    };
