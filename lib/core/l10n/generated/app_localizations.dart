import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Diatona'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Chord Training'**
  String get homeTitle;

  /// No description provided for @getReady.
  ///
  /// In en, this message translates to:
  /// **'Get Ready'**
  String get getReady;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// No description provided for @skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skipped;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @timeLimit.
  ///
  /// In en, this message translates to:
  /// **'Time Limit'**
  String get timeLimit;

  /// No description provided for @noTimeLimit.
  ///
  /// In en, this message translates to:
  /// **'∞'**
  String get noTimeLimit;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'{n}s'**
  String seconds(int n);

  /// No description provided for @levelMajor.
  ///
  /// In en, this message translates to:
  /// **'Major'**
  String get levelMajor;

  /// No description provided for @levelMinor.
  ///
  /// In en, this message translates to:
  /// **'Minor'**
  String get levelMinor;

  /// No description provided for @levelAug.
  ///
  /// In en, this message translates to:
  /// **'Augmented'**
  String get levelAug;

  /// No description provided for @levelDim.
  ///
  /// In en, this message translates to:
  /// **'Diminished'**
  String get levelDim;

  /// No description provided for @levelSus.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get levelSus;

  /// No description provided for @levelSeventh.
  ///
  /// In en, this message translates to:
  /// **'7th'**
  String get levelSeventh;

  /// No description provided for @levelMaj7.
  ///
  /// In en, this message translates to:
  /// **'Major 7th'**
  String get levelMaj7;

  /// No description provided for @levelM7.
  ///
  /// In en, this message translates to:
  /// **'Minor 7th'**
  String get levelM7;

  /// No description provided for @levelDim7.
  ///
  /// In en, this message translates to:
  /// **'Diminished 7th'**
  String get levelDim7;

  /// No description provided for @levelHalfDim7.
  ///
  /// In en, this message translates to:
  /// **'Half-Diminished 7th'**
  String get levelHalfDim7;

  /// No description provided for @levelMMaj7.
  ///
  /// In en, this message translates to:
  /// **'Minor-Major 7th'**
  String get levelMMaj7;

  /// No description provided for @levelAugMaj7.
  ///
  /// In en, this message translates to:
  /// **'Augmented-Major 7th'**
  String get levelAugMaj7;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level {number}: {name}'**
  String levelLabel(int number, String name);

  /// No description provided for @chordPool.
  ///
  /// In en, this message translates to:
  /// **'Chord Pool'**
  String get chordPool;

  /// No description provided for @chordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} chords'**
  String chordsCount(int count);

  /// No description provided for @cumulativePool.
  ///
  /// In en, this message translates to:
  /// **'Cumulative pool'**
  String get cumulativePool;

  /// No description provided for @cumulativePoolHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Cumulative Pool'**
  String get cumulativePoolHelpTitle;

  /// No description provided for @cumulativePoolHelpBody.
  ///
  /// In en, this message translates to:
  /// **'When enabled, the chord pool includes all types from level 1 up to the selected level. When disabled, only the chord type of the selected level is used.'**
  String get cumulativePoolHelpBody;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @menuLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get menuLearning;

  /// No description provided for @menuTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get menuTraining;

  /// No description provided for @menuNoteTrainer.
  ///
  /// In en, this message translates to:
  /// **'Note Trainer'**
  String get menuNoteTrainer;

  /// No description provided for @menuChordTraining.
  ///
  /// In en, this message translates to:
  /// **'Chord Training'**
  String get menuChordTraining;

  /// No description provided for @menuDonate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get menuDonate;

  /// No description provided for @menuAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menuAbout;

  /// No description provided for @menuCredits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get menuCredits;

  /// No description provided for @menuReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get menuReference;

  /// No description provided for @menuTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get menuTools;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @noteTrainerDisplayModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Display Mode'**
  String get noteTrainerDisplayModeLabel;

  /// No description provided for @noteLevelStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get noteLevelStandard;

  /// No description provided for @noteLevelAccidentals.
  ///
  /// In en, this message translates to:
  /// **'Accidentals'**
  String get noteLevelAccidentals;

  /// No description provided for @chordDisplay.
  ///
  /// In en, this message translates to:
  /// **'Chord Display'**
  String get chordDisplay;

  /// No description provided for @displayModeSymbol.
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get displayModeSymbol;

  /// No description provided for @displayModeTrebleClef.
  ///
  /// In en, this message translates to:
  /// **'Treble Clef'**
  String get displayModeTrebleClef;

  /// No description provided for @displayModeBassClef.
  ///
  /// In en, this message translates to:
  /// **'Bass Clef'**
  String get displayModeBassClef;

  /// No description provided for @displayModeLetterNames.
  ///
  /// In en, this message translates to:
  /// **'Letter Names'**
  String get displayModeLetterNames;

  /// No description provided for @displayModeGuitar.
  ///
  /// In en, this message translates to:
  /// **'Guitar'**
  String get displayModeGuitar;

  /// No description provided for @displayModeUkulele.
  ///
  /// In en, this message translates to:
  /// **'Ukulele'**
  String get displayModeUkulele;

  /// No description provided for @refLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load references: {error}'**
  String refLoadError(String error);

  /// No description provided for @refHowItWorksTooltip.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get refHowItWorksTooltip;

  /// No description provided for @refTapKeyToExplore.
  ///
  /// In en, this message translates to:
  /// **'Tap a key to explore'**
  String get refTapKeyToExplore;

  /// No description provided for @refAscendingFifths.
  ///
  /// In en, this message translates to:
  /// **'Ascending 5ths (clockwise) →'**
  String get refAscendingFifths;

  /// No description provided for @refAscendingFourths.
  ///
  /// In en, this message translates to:
  /// **'← Ascending 4ths (counter-clockwise)'**
  String get refAscendingFourths;

  /// No description provided for @refNoAccidentals.
  ///
  /// In en, this message translates to:
  /// **'No accidentals'**
  String get refNoAccidentals;

  /// No description provided for @refKeySignature.
  ///
  /// In en, this message translates to:
  /// **'Key signature'**
  String get refKeySignature;

  /// No description provided for @refDiatonicChords.
  ///
  /// In en, this message translates to:
  /// **'Diatonic chords'**
  String get refDiatonicChords;

  /// No description provided for @refTapChordFunction.
  ///
  /// In en, this message translates to:
  /// **'Tap a chord to see its function'**
  String get refTapChordFunction;

  /// No description provided for @refTapLevelExpand.
  ///
  /// In en, this message translates to:
  /// **'Tap a level to expand subdivisions'**
  String get refTapLevelExpand;

  /// No description provided for @refWholeStepLegend.
  ///
  /// In en, this message translates to:
  /// **'W = whole step (2 frets)'**
  String get refWholeStepLegend;

  /// No description provided for @refHalfStepLegend.
  ///
  /// In en, this message translates to:
  /// **'H = half step (1 fret)'**
  String get refHalfStepLegend;

  /// No description provided for @refMinorNatural.
  ///
  /// In en, this message translates to:
  /// **'Natural'**
  String get refMinorNatural;

  /// No description provided for @refMinorHarmonic.
  ///
  /// In en, this message translates to:
  /// **'Harmonic'**
  String get refMinorHarmonic;

  /// No description provided for @refMinorMelodic.
  ///
  /// In en, this message translates to:
  /// **'Melodic'**
  String get refMinorMelodic;

  /// No description provided for @refScaleNotesFrom.
  ///
  /// In en, this message translates to:
  /// **'Scale notes (from {note}, using {parentKey}):'**
  String refScaleNotesFrom(String note, String parentKey);

  /// No description provided for @refModeFormula.
  ///
  /// In en, this message translates to:
  /// **'Formula'**
  String get refModeFormula;

  /// No description provided for @refModeCharacteristic.
  ///
  /// In en, this message translates to:
  /// **'Characteristic'**
  String get refModeCharacteristic;

  /// No description provided for @refModeMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get refModeMood;

  /// No description provided for @refPentatonicLegend.
  ///
  /// In en, this message translates to:
  /// **'● = note  ⊙ = root  Tap boxes above to toggle'**
  String get refPentatonicLegend;

  /// No description provided for @refFnTonic.
  ///
  /// In en, this message translates to:
  /// **'Tonic'**
  String get refFnTonic;

  /// No description provided for @refFnSubdominant.
  ///
  /// In en, this message translates to:
  /// **'Subdom.'**
  String get refFnSubdominant;

  /// No description provided for @refFnDominant.
  ///
  /// In en, this message translates to:
  /// **'Dom.'**
  String get refFnDominant;

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Chord recognition trainer. Play the root note on your instrument and train your ear.'**
  String get aboutAppDescription;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @menuEarTrainer.
  ///
  /// In en, this message translates to:
  /// **'Ear Trainer'**
  String get menuEarTrainer;

  /// No description provided for @earTrainerDirection.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get earTrainerDirection;

  /// No description provided for @earTrainerAscending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get earTrainerAscending;

  /// No description provided for @earTrainerDescending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get earTrainerDescending;

  /// No description provided for @earTrainerHarmonic.
  ///
  /// In en, this message translates to:
  /// **'Harmonic'**
  String get earTrainerHarmonic;

  /// No description provided for @earTrainerRandom.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get earTrainerRandom;

  /// No description provided for @earTrainerCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get earTrainerCustom;

  /// No description provided for @earTrainerSelectAtLeastTwo.
  ///
  /// In en, this message translates to:
  /// **'Select at least 2 intervals'**
  String get earTrainerSelectAtLeastTwo;

  /// No description provided for @earTrainerWhatInterval.
  ///
  /// In en, this message translates to:
  /// **'What interval is this?'**
  String get earTrainerWhatInterval;

  /// No description provided for @earTrainerWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong!'**
  String get earTrainerWrong;

  /// No description provided for @intervalMinSecond.
  ///
  /// In en, this message translates to:
  /// **'Minor 2nd'**
  String get intervalMinSecond;

  /// No description provided for @intervalMajSecond.
  ///
  /// In en, this message translates to:
  /// **'Major 2nd'**
  String get intervalMajSecond;

  /// No description provided for @intervalMinThird.
  ///
  /// In en, this message translates to:
  /// **'Minor 3rd'**
  String get intervalMinThird;

  /// No description provided for @intervalMajThird.
  ///
  /// In en, this message translates to:
  /// **'Major 3rd'**
  String get intervalMajThird;

  /// No description provided for @intervalPerfectFourth.
  ///
  /// In en, this message translates to:
  /// **'Perfect 4th'**
  String get intervalPerfectFourth;

  /// No description provided for @intervalTritone.
  ///
  /// In en, this message translates to:
  /// **'Tritone'**
  String get intervalTritone;

  /// No description provided for @intervalPerfectFifth.
  ///
  /// In en, this message translates to:
  /// **'Perfect 5th'**
  String get intervalPerfectFifth;

  /// No description provided for @intervalMinSixth.
  ///
  /// In en, this message translates to:
  /// **'Minor 6th'**
  String get intervalMinSixth;

  /// No description provided for @intervalMajSixth.
  ///
  /// In en, this message translates to:
  /// **'Major 6th'**
  String get intervalMajSixth;

  /// No description provided for @intervalMinSeventh.
  ///
  /// In en, this message translates to:
  /// **'Minor 7th'**
  String get intervalMinSeventh;

  /// No description provided for @intervalMajSeventh.
  ///
  /// In en, this message translates to:
  /// **'Major 7th'**
  String get intervalMajSeventh;

  /// No description provided for @intervalOctave.
  ///
  /// In en, this message translates to:
  /// **'Octave'**
  String get intervalOctave;

  /// No description provided for @rmChooseRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Choose a Roadmap'**
  String get rmChooseRoadmap;

  /// No description provided for @rmChooseRoadmapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select an instrument or subject to begin your learning path.'**
  String get rmChooseRoadmapSubtitle;

  /// No description provided for @rmChangeRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get rmChangeRoadmap;

  /// No description provided for @rmTopicsCompleted.
  ///
  /// In en, this message translates to:
  /// **'{completed} / {total} topics completed'**
  String rmTopicsCompleted(int completed, int total);

  /// No description provided for @rmObjectives.
  ///
  /// In en, this message translates to:
  /// **'Objectives'**
  String get rmObjectives;

  /// No description provided for @rmCommonMistakes.
  ///
  /// In en, this message translates to:
  /// **'Common Mistakes'**
  String get rmCommonMistakes;

  /// No description provided for @rmPracticeTips.
  ///
  /// In en, this message translates to:
  /// **'Practice Tips'**
  String get rmPracticeTips;

  /// No description provided for @rmTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get rmTags;

  /// No description provided for @rmResources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get rmResources;

  /// No description provided for @rmTakeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take Quiz'**
  String get rmTakeQuiz;

  /// No description provided for @rmMarkComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get rmMarkComplete;

  /// No description provided for @rmMarkIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as Incomplete'**
  String get rmMarkIncomplete;

  /// No description provided for @rmQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get rmQuiz;

  /// No description provided for @rmQuizScore.
  ///
  /// In en, this message translates to:
  /// **'{correct} / {total} correct'**
  String rmQuizScore(int correct, int total);

  /// No description provided for @rmQuizPerfect.
  ///
  /// In en, this message translates to:
  /// **'Perfect score! {correct} / {total} correct'**
  String rmQuizPerfect(int correct, int total);

  /// No description provided for @rmQuizSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get rmQuizSubmit;

  /// No description provided for @rmQuizDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get rmQuizDone;

  /// No description provided for @rmQuizRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get rmQuizRetake;

  /// No description provided for @rmLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String rmLoadError(String error);

  /// No description provided for @rmDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get rmDismiss;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
