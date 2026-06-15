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

  /// No description provided for @noteTrainerClefLabel.
  ///
  /// In en, this message translates to:
  /// **'Clef'**
  String get noteTrainerClefLabel;

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
