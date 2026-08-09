# Project Structure

Diatona is a Flutter app for music reference and training. Everything runs locally,
there is no backend. Chord data and reference material live as JSON files under
`database/` and are bundled as assets.

## Tech stack

- Flutter, Dart SDK 3.8+
- flutter_riverpod 3.x for state (`Notifier` / `NotifierProvider` / `Provider`)
- shared_preferences for settings persistence
- pitch_detector_dart + record for microphone pitch detection
- audioplayers for sound effects and piano samples
- flutter_localizations + intl for ARB based i18n
- wakelock_plus to keep the screen on during training
- url_launcher for external links in the about/credits screens

## Folders

```text
lib/
  main.dart                 Loads SharedPreferences, chord and scale data, then runs App
  app.dart                  MaterialApp: theme, locale, localization delegates, SplashScreen
  core/
    theme/app_theme.dart    Theme variants built from a shared palette
    l10n/arb/               Source strings: app_en, app_pt, app_pt_BR, app_es
    l10n/generated/         Output of flutter gen-l10n, not edited by hand
    widgets/                Widgets shared between features (training overlay)
  features/
    splash/                 First screen, routes into the main menu
    main_menu/              Grid of the top level sections
    trainer/                Chord trainer: domain, chord data, settings repository, providers
    note_trainer/           Staff note reading trainer
    ear_trainer/            Interval ear training with piano playback
    scale_trainer/          Scale playing trainer, scale spelling and pools
    references/             Circle of fifths, CAGED, modes, scales and other charts
    home/                   Chord trainer setup screen (level, interval, display mode)
    settings/               Theme, language and training preferences
    about/                  About and credits
    audio/                  pitch_detection_service.dart
database/
  trainer/                  chords, chord qualities, notes, intervals, scales, voicings
  references/               Reference cards shown in the references section
assets/
  logo/, instrument_sounds/piano/
```

Each feature follows the same split: `domain/` for value objects and enums, `data/`
for repositories and providers, `presentation/` for screens and widgets.

## State and persistence

`SharedPreferences` is read once in `main()` and injected through a `ProviderScope`
override of `sharedPreferencesProvider`. Providers never call
`SharedPreferences.getInstance()` themselves.

`SettingsRepository` (`lib/features/trainer/data/settings_repository.dart`) is the only
place that touches preference keys. It holds settings for all four trainers plus theme
and locale, all prefixed with `pref_`.

The notifiers in `lib/features/trainer/data/providers.dart` expose the selected level,
interval, cumulative mode, display mode, theme and locale.

## Chord trainer behaviour

- The screen shows a chord symbol, the user plays its root note on their instrument.
- `PitchDetectionService` captures microphone audio, converts the detected frequency to
  a chromatic note and emits it as a stream.
- A chord advances when the detected note matches `chord.rootNote` or `chord.altRootNote`.
- A 2 second countdown runs before the first chord.
- On a match: success overlay and sound, then the next chord after 800 ms.
- A 500 ms silence window prevents a sustained note from triggering twice.
- An optional time limit advances to the next chord if nothing is played in time.
- The same chord is never shown twice in a row.

Levels are cumulative by default, so level 3 draws from major, minor and augmented.
`buildChordPool(level)` returns the cumulative pool and `buildChordPoolSingle(level)`
returns a single level pool.

| Level | Chord type | `ChordType` |
| ----- | ---------- | ----------- |
| 1 | Major | `major` |
| 2 | Minor | `minor` |
| 3 | Augmented | `aug` |
| 4 | Diminished | `dim` |
| 5 | Suspended | `sus` |
| 6 | 7th | `seventh` |
| 7 | Major 7th | `maj7` |
| 8 | Minor 7th | `m7` |
| 9 | Diminished 7th | `dim7` |
| 10 | Half-diminished 7th | `halfDim7` |
| 11 | Minor-major 7th | `mMaj7` |
| 12 | Augmented-major 7th | `augMaj7` |

## Scale trainer behaviour

- The screen shows a scale, for example `Bb Dorian`, with its notes listed below.
- The user plays the notes in order on their instrument. Each note that matches fills
  in, the next one is outlined, notes that do not match are ignored.
- Octaves are ignored, only the pitch class is compared, so the scale can be played
  anywhere on the instrument.
- Completing the last note shows the success overlay and the next scale follows after
  900 ms, with the same 500 ms silence window the chord trainer uses.
- Direction is ascending, descending or up and down. Every direction closes the octave,
  so a seven note scale is eight notes to play, or fifteen going up and down.
- Keys are either the seven naturals or all twelve, and the sharp or flat spelling of a
  key is picked per scale, whichever needs fewer accidentals: `Db Major`, `C# Locrian`.
- Scales are spelled with one letter per degree, so `Bb Dorian` reads
  `Bb C Db Eb F G Ab Bb` rather than mixing sharps and flats.

Semitone patterns come from `database/trainer/scales.json`, loaded by `initScaleData()`.
Levels are cumulative by default, like the chord trainer.

| Level | Scale | `ScaleType` |
| ----- | ----- | ----------- |
| 1 | Major | `major` |
| 2 | Natural Minor | `naturalMinor` |
| 3 | Dorian | `dorian` |
| 4 | Mixolydian | `mixolydian` |
| 5 | Lydian | `lydian` |
| 6 | Phrygian | `phrygian` |
| 7 | Locrian | `locrian` |
| 8 | Harmonic Minor | `harmonicMinor` |
| 9 | Melodic Minor | `melodicMinor` |

## Translations

1. Add the key to `lib/core/l10n/arb/app_en.arb`, which is the template.
2. Add the same key to `app_pt.arb`, `app_pt_BR.arb` and `app_es.arb`.
3. Run `flutter gen-l10n`.

Files under `lib/core/l10n/generated/` are regenerated by that command, so changes made
there by hand are lost.

## Content files

Everything under `assets/` and `database/` is declared in `pubspec.yaml`.

## Commands

```bash
flutter pub get       # install packages
flutter gen-l10n      # regenerate localizations after editing ARB files
flutter analyze       # static analysis, should stay at zero issues
flutter run           # run on a connected device or emulator
flutter pub upgrade   # upgrade within the current constraints
```

Donations are handled in the README only, not in the app. Google Play and the App
Store both restrict donation links for developers who are not registered charities,
so there is no donate screen and no link out to PayPal, Buy Me a Coffee or PIX.
