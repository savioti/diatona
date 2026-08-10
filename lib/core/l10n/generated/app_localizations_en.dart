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
  String get menuTraining => 'Training';

  @override
  String get menuNoteTrainer => 'Note Trainer';

  @override
  String get menuChordTraining => 'Chord Training';

  @override
  String get menuAbout => 'About';

  @override
  String get menuCredits => 'Credits';

  @override
  String get creditsOpenSourceLicenses => 'Open source licenses';

  @override
  String get creditsOpenSourceLicensesSubtitle =>
      'Licenses of the packages used by this app';

  @override
  String get menuReference => 'Reference';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get noteTrainerDisplayModeLabel => 'Display Mode';

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
  String get displayModeLetterNames => 'Letter Names';

  @override
  String get displayModeGuitar => 'Guitar';

  @override
  String get displayModeUkulele => 'Ukulele';

  @override
  String refLoadError(String error) {
    return 'Failed to load references: $error';
  }

  @override
  String get refHowItWorksTooltip => 'How it works';

  @override
  String get refTapKeyToExplore => 'Tap a key to explore';

  @override
  String get refAscendingFifths => 'Ascending 5ths (clockwise) →';

  @override
  String get refAscendingFourths => '← Ascending 4ths (counter-clockwise)';

  @override
  String get refNoAccidentals => 'No accidentals';

  @override
  String get refKeySignature => 'Key signature';

  @override
  String get refDiatonicChords => 'Diatonic chords';

  @override
  String get refTapChordFunction => 'Tap a chord to see its function';

  @override
  String get refTapLevelExpand => 'Tap a level to expand subdivisions';

  @override
  String get refWholeStepLegend => 'W = whole step (2 frets)';

  @override
  String get refHalfStepLegend => 'H = half step (1 fret)';

  @override
  String get refMinorNatural => 'Natural';

  @override
  String get refMinorHarmonic => 'Harmonic';

  @override
  String get refMinorMelodic => 'Melodic';

  @override
  String refScaleNotesFrom(String note, String parentKey) {
    return 'Scale notes (from $note, using $parentKey):';
  }

  @override
  String get refModeFormula => 'Formula';

  @override
  String get refModeCharacteristic => 'Characteristic';

  @override
  String get refModeMood => 'Mood';

  @override
  String get refPentatonicLegend =>
      '● = note  ⊙ = root  Tap boxes above to toggle';

  @override
  String get refFnTonic => 'Tonic';

  @override
  String get refFnSubdominant => 'Subdom.';

  @override
  String get refFnDominant => 'Dom.';

  @override
  String get aboutAppDescription =>
      'Chord recognition trainer. Play the root note on your instrument and train your ear.';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get menuEarTrainer => 'Ear Trainer';

  @override
  String get earTrainerDirection => 'Direction';

  @override
  String get earTrainerAscending => 'Ascending';

  @override
  String get earTrainerDescending => 'Descending';

  @override
  String get earTrainerHarmonic => 'Harmonic';

  @override
  String get earTrainerRandom => 'Random';

  @override
  String get trainingCustom => 'Custom';

  @override
  String get earTrainerSelectAtLeastTwo => 'Select at least 2 intervals';

  @override
  String get earTrainerWhatInterval => 'What interval is this?';

  @override
  String get earTrainerWrong => 'Wrong!';

  @override
  String get intervalMinSecond => 'Minor 2nd';

  @override
  String get intervalMajSecond => 'Major 2nd';

  @override
  String get intervalMinThird => 'Minor 3rd';

  @override
  String get intervalMajThird => 'Major 3rd';

  @override
  String get intervalPerfectFourth => 'Perfect 4th';

  @override
  String get intervalTritone => 'Tritone';

  @override
  String get intervalPerfectFifth => 'Perfect 5th';

  @override
  String get intervalMinSixth => 'Minor 6th';

  @override
  String get intervalMajSixth => 'Major 6th';

  @override
  String get intervalMinSeventh => 'Minor 7th';

  @override
  String get intervalMajSeventh => 'Major 7th';

  @override
  String get intervalOctave => 'Octave';

  @override
  String get menuScaleTrainer => 'Scale Trainer';

  @override
  String get trainingDirection => 'Direction';

  @override
  String get trainingAscending => 'Ascending';

  @override
  String get trainingDescending => 'Descending';

  @override
  String get trainingUpAndDown => 'Up and down';

  @override
  String get trainingKeys => 'Keys';

  @override
  String get trainingKeysNaturals => 'Naturals';

  @override
  String get trainingKeysAll => 'All keys';

  @override
  String get trainingPlayInOrder => 'Play the notes in order';

  @override
  String get trainingFindTheNotes =>
      'Work out the notes and play them in order';

  @override
  String get trainingShowNotes => 'Show the notes';

  @override
  String get trainingShowNotesHelpTitle => 'Show the Notes';

  @override
  String get trainingShowNotesHelpBody =>
      'When enabled, the notes are listed before you play them. When disabled, only the name is shown and the notes are up to you. Either way, three wrong notes move you on to the next round.';

  @override
  String get trainingMissed => 'Missed';

  @override
  String trainingRootLabel(String root, String name) {
    return '$root $name';
  }

  @override
  String get scaleMajor => 'Major';

  @override
  String get scaleNaturalMinor => 'Natural Minor';

  @override
  String get scaleDorian => 'Dorian';

  @override
  String get scaleMixolydian => 'Mixolydian';

  @override
  String get scaleLydian => 'Lydian';

  @override
  String get scalePhrygian => 'Phrygian';

  @override
  String get scaleLocrian => 'Locrian';

  @override
  String get scaleHarmonicMinor => 'Harmonic Minor';

  @override
  String get scaleMelodicMinor => 'Melodic Minor';

  @override
  String get menuArpeggioTrainer => 'Arpeggio Trainer';

  @override
  String get arpeggioInversion => 'Inversion';

  @override
  String get arpeggioRootPosition => 'Root position';

  @override
  String get arpeggioFirstInversion => '1st inversion';

  @override
  String get arpeggioSecondInversion => '2nd inversion';

  @override
  String get arpeggioThirdInversion => '3rd inversion';

  @override
  String get arpeggioRandomInversion => 'Random';

  @override
  String get arpeggioOctaves => 'Octaves';

  @override
  String get menuIntervalTrainer => 'Interval Trainer';

  @override
  String get trainingMixed => 'Mixed';

  @override
  String get intervalPlayRoot => 'Play the root';

  @override
  String get intervalPlayRootHelpTitle => 'Play the Root';

  @override
  String get intervalPlayRootHelpBody =>
      'When enabled, a round is two notes: the one the interval starts from, then the one it lands on. When disabled, only the note it lands on is asked for, which is quicker but never sounds the interval.';

  @override
  String get playbackPlaying => 'Playing…';

  @override
  String get playbackReplay => 'Replay';

  @override
  String get refProgressionsArpeggiate => 'Arpeggiate';

  @override
  String get refProgressionsSlow => 'Slow';

  @override
  String get refProgressionsMedium => 'Medium';

  @override
  String get refProgressionsFast => 'Fast';

  @override
  String get refModulationFrom => 'From';

  @override
  String get refModulationTo => 'To';

  @override
  String refModulationDistance(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count steps apart on the circle of fifths',
      one: '1 step apart on the circle of fifths',
      zero: 'The same tonic',
    );
    return '$_temp0';
  }

  @override
  String refModulationSharedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shared chords',
      one: '1 shared chord',
      zero: 'No shared chords',
    );
    return '$_temp0';
  }

  @override
  String get refModulationNoPivots =>
      'These two keys have no chord in common, so there is no pivot to turn on. Getting from one to the other takes a chord that belongs to neither.';

  @override
  String get refModulationTapPivot =>
      'Tap a shared chord to hear it turn: the pivot, then the dominant and tonic of the key you are arriving at.';

  @override
  String get menuRomanTrainer => 'Roman Numerals';

  @override
  String get menuProgressionTrainer => 'Progression Trainer';

  @override
  String get menuProgressionEarTrainer => 'Progression Ear';

  @override
  String get menuCadenceTrainer => 'Cadences';

  @override
  String get progressionPool => 'Progressions';

  @override
  String get progressionTempo => 'Tempo';

  @override
  String get progressionTrainerHint =>
      'The numerals are shown and the chords are not. Working out which chords they are in the key is the exercise.';

  @override
  String get progressionArpeggiate => 'Arpeggiate the chords';

  @override
  String get progressionArpeggiateHelpTitle => 'Arpeggiate the Chords';

  @override
  String get progressionArpeggiateHelpBody =>
      'When enabled, a round asks for every tone of every chord rather than the roots alone, so a four chord progression is twelve notes. When disabled, only the root of each chord is asked for, which is the progression as a bass line.';

  @override
  String get progressionArpeggiatePlaybackHelpTitle => 'Arpeggiate';

  @override
  String get progressionArpeggiatePlaybackHelpBody =>
      'When enabled, the notes of each chord arrive one after another rather than together. It is easier to pick the chord apart that way, and harder to hear the progression as a whole.';

  @override
  String get progressionEarWhich => 'Which progression?';

  @override
  String get progressionEarHint =>
      'Pick at least two. Each round plays one of them in a key drawn at random.';

  @override
  String get cadencePool => 'Cadences';

  @override
  String get cadenceWhich => 'Which cadence?';

  @override
  String get cadenceHint =>
      'Every round opens on the tonic, so that the key is heard before the cadence lands on it.';

  @override
  String get cadenceAuthentic => 'Authentic';

  @override
  String get cadencePlagal => 'Plagal';

  @override
  String get cadenceHalf => 'Half';

  @override
  String get cadenceDeceptive => 'Deceptive';

  @override
  String get cadenceIncludeMinor => 'Include minor keys';

  @override
  String get cadenceIncludeMinorHelpTitle => 'Include Minor Keys';

  @override
  String get cadenceIncludeMinorHelpBody =>
      'When enabled, half the rounds are in a minor key. Minor uses the harmonic minor scale, which is the one that gives a cadence the major fifth degree it needs.';

  @override
  String get romanDirection => 'Direction';

  @override
  String get romanScales => 'Scales';

  @override
  String get romanModeNumeralToChord => 'Numeral → Chord';

  @override
  String get romanModeChordToNumeral => 'Chord → Numeral';

  @override
  String get romanWhichChord => 'Which chord is this degree?';

  @override
  String get romanWhichDegree => 'Which degree is this chord?';

  @override
  String get romanSevenths => 'Seventh chords';

  @override
  String get romanSeventhsHelpTitle => 'Seventh Chords';

  @override
  String get romanSeventhsHelpBody =>
      'When enabled, the degrees are stacked one third further, so the fifth degree of a major key is V7 rather than V. It is the same seven degrees, named more precisely.';

  @override
  String get romanHearChord => 'Hear the chord';

  @override
  String get romanHearChordHelpTitle => 'Hear the Chord';

  @override
  String get romanHearChordHelpBody =>
      'When enabled, the chord is played once the answer is revealed. Naming a degree is a written skill until you have heard what it sounds like.';
}
