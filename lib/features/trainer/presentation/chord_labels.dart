import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/chord_type.dart';

String chordTypeName(ChordType type, AppLocalizations l10n) => switch (type) {
      ChordType.major => l10n.levelMajor,
      ChordType.minor => l10n.levelMinor,
      ChordType.aug => l10n.levelAug,
      ChordType.dim => l10n.levelDim,
      ChordType.sus => l10n.levelSus,
      ChordType.seventh => l10n.levelSeventh,
      ChordType.maj7 => l10n.levelMaj7,
      ChordType.m7 => l10n.levelM7,
      ChordType.dim7 => l10n.levelDim7,
      ChordType.halfDim7 => l10n.levelHalfDim7,
      ChordType.mMaj7 => l10n.levelMMaj7,
      ChordType.augMaj7 => l10n.levelAugMaj7,
    };

String chordTypeNameForLevel(int level, AppLocalizations l10n) => chordTypeName(
      ChordType.values[(level - 1).clamp(0, ChordType.values.length - 1)],
      l10n,
    );
