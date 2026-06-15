// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Diatona';

  @override
  String get homeTitle => 'Chord Training';

  @override
  String get getReady => 'Get Ready';

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stop';

  @override
  String get next => 'Next';

  @override
  String get correct => 'Correct!';

  @override
  String get skipped => 'Skipped';

  @override
  String get level => 'Level';

  @override
  String get timeLimit => 'Time Limit';

  @override
  String get noTimeLimit => '∞';

  @override
  String seconds(int n) {
    return '${n}s';
  }

  @override
  String get levelMajor => 'Major';

  @override
  String get levelMinor => 'Minor';

  @override
  String get levelAug => 'Augmented';

  @override
  String get levelDim => 'Diminished';

  @override
  String get levelSus => 'Suspended';

  @override
  String get levelSeventh => '7th';

  @override
  String get levelMaj7 => 'Major 7th';

  @override
  String get levelM7 => 'Minor 7th';

  @override
  String get levelDim7 => 'Diminished 7th';

  @override
  String get levelHalfDim7 => 'Half-Diminished 7th';

  @override
  String get levelMMaj7 => 'Minor-Major 7th';

  @override
  String get levelAugMaj7 => 'Augmented-Major 7th';

  @override
  String levelLabel(int number, String name) {
    return 'Level $number: $name';
  }

  @override
  String get chordPool => 'Chord Pool';

  @override
  String chordsCount(int count) {
    return '$count chords';
  }

  @override
  String get cumulativePool => 'Cumulative pool';

  @override
  String get cumulativePoolHelpTitle => 'Cumulative Pool';

  @override
  String get cumulativePoolHelpBody =>
      'When enabled, the chord pool includes all types from level 1 up to the selected level. When disabled, only the chord type of the selected level is used.';

  @override
  String get ok => 'OK';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get menuLearning => 'Learning';

  @override
  String get menuTraining => 'Training';

  @override
  String get menuNoteTrainer => 'Note Trainer';

  @override
  String get menuChordTraining => 'Chord Training';

  @override
  String get menuDonate => 'Donate';

  @override
  String get menuAbout => 'About';

  @override
  String get menuCredits => 'Credits';

  @override
  String get menuReference => 'Reference';

  @override
  String get menuTools => 'Tools';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get noteTrainerClefLabel => 'Clef';

  @override
  String get noteLevelStandard => 'Standard';

  @override
  String get noteLevelAccidentals => 'Accidentals';

  @override
  String get chordDisplay => 'Chord Display';

  @override
  String get displayModeSymbol => 'Symbol';

  @override
  String get displayModeTrebleClef => 'Treble Clef';

  @override
  String get displayModeBassClef => 'Bass Clef';

  @override
  String get displayModeGuitar => 'Guitar';

  @override
  String get displayModeUkulele => 'Ukulele';
}
