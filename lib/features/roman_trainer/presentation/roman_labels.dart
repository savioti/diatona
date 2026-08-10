import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/roman_question.dart';

String romanDrillModeName(RomanDrillMode mode, AppLocalizations l10n) =>
    switch (mode) {
      RomanDrillMode.numeralToChord => l10n.romanModeNumeralToChord,
      RomanDrillMode.chordToNumeral => l10n.romanModeChordToNumeral,
      RomanDrillMode.mixed => l10n.trainingMixed,
    };
