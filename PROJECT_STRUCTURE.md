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
  main.dart                 Loads SharedPreferences, chord, scale, arpeggio and harmony data
  app.dart                  MaterialApp: theme, locale, localization delegates, SplashScreen
  core/
    theme/app_theme.dart    Theme variants built from a shared palette
    l10n/arb/               Source strings: app_en, app_pt, app_pt_BR, app_es
    l10n/generated/         Output of flutter gen-l10n, not edited by hand
    audio/                  Piano sample paths and the chord playback service
    widgets/                Widgets shared between features (overlay, answer buttons,
                            replay control, session stats)
    sequence_trainer/       Engine behind the scale, arpeggio and progression trainers
    harmony/                Diatonic chords, progressions, cadences and voicings
    harmony_ear/            Engine behind the progression and cadence ear trainers
  features/
    splash/                 First screen, routes into the main menu
    main_menu/              Grid of the top level sections
    trainer/                Chord trainer: domain, chord data, settings repository, providers
    note_trainer/           Staff note reading trainer
    ear_trainer/            Interval ear training with piano playback
    scale_trainer/          Scale pools for the sequence engine
    arpeggio_trainer/       Arpeggio pools for the sequence engine
    interval_trainer/       Interval pools for the sequence engine
    progression_trainer/    Progression pools for the sequence engine
    roman_trainer/          Roman numeral drill, tap answered
    progression_ear_trainer/  Progression pools for the harmony ear engine
    cadence_trainer/        Cadences for the harmony ear engine
    references/             Circle of fifths, CAGED, modes, progressions and other charts
    home/                   Chord trainer setup screen (level, interval, display mode)
    settings/               Theme, language and training preferences
    about/                  About and credits
    audio/                  pitch_detection_service.dart
database/
  trainer/                  chords, chord qualities, notes, intervals, scales, voicings,
                            progressions
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
place that touches preference keys. It holds settings for all ten trainers plus theme
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

## Sequence trainer engine

The scale, arpeggio, interval and progression trainers are the same exercise over
different notes, so they run on one engine in `lib/core/sequence_trainer/`. A feature
only builds the pool and names the rounds, everything below is shared.

- A `NoteSequence` is what to call the round, the note names to show, and the pitch
  classes to listen for, already in the order they are expected.
- The screen shows the name and one blank slot per note. Working out which notes those
  are is the exercise.
- The user plays the notes in order on their instrument. A correct note fills its slot
  with the note name and the next slot is outlined.
- The `Show the notes` option, off by default, lists the notes up front instead. The
  rest of the round works the same way.
- Octaves are ignored, only the pitch class is compared, so a round can be played
  anywhere on the instrument.
- A wrong note costs one of three tries, shown as crosses under the name. The third one
  reveals the right notes and moves on after 1200 ms.
- Slots the round hands over cost nothing, `NoteSequence.isGiven`. Fumbling the root of
  an interval, which the title names, is a fumble rather than a wrong answer.
- A wrong note only counts once it has been detected twice in a row, so a single bad
  reading from the detector is not charged to the user.
- A pitch class that has just been answered is ignored until a different one arrives,
  so a note still ringing is not read as a wrong answer to the slot after it.
- Completing the last note shows the success overlay and the next round follows after
  900 ms, with the same 500 ms silence window the chord trainer uses.
- Direction is ascending, descending or up and down. Scales and arpeggios close their
  octave, the interval trainer reads the third option as mixed instead.
- Keys are either the seven naturals or all twelve.
- `NoteSequence.hiddenFrom` keeps the first slots named while the rest stay blank, which
  is how an interval round shows the note it starts from.
- `note_spelling.dart` names each note from a `NoteDegree`, which carries how many
  letters above the root the note sits and how many semitones. That is what keeps
  `Bb Dorian` spelled Bb C Db Eb F G Ab and `Cdim7` spelled C Eb Gb Bbb.

## Scale trainer

Semitone patterns come from `database/trainer/scales.json`, loaded by `initScaleData()`.
One letter per degree, plus the closing octave, so a seven note scale is eight notes to
play and fifteen going up and down. The sharp or flat spelling of a key is picked per
scale, whichever needs fewer accidentals: `Db Major`, `C# Locrian`.

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

## Arpeggio trainer

Chord tones come from `database/trainer/chord_qualities.json`, loaded by
`initArpeggioData()`. The pool is the chord trainer's own pool, so the levels are the
same twelve qualities in the same order: level 6 is seventh chords in both trainers.

The `formula` field of a quality gives the letter each tone takes, `b3` being a third
and `bb7` a seventh. Reading it from the formula rather than counting in thirds is what
keeps `Csus4` spelled C F G.

- Inversions rotate the tones and close on the one the round started from, so `Cmaj7`
  in first inversion is E G B C E. The inversion is named under the chord symbol, which
  says where to start without giving away the note.
- `Random` draws every inversion of every chord, including the third inversion of
  seventh chords, which has no chip of its own.
- Two octaves repeat the run an octave up before closing, so `C` becomes C E G C E G C.

## Interval trainer

A round is two notes: the root, then the note an interval away from it. The screen shows
`C Major 3rd` with the first slot named and the second blank. Playing both is what makes
it an interval rather than a spelling drill, since that is when the interval sounds.

`Play the root`, on by default, is what puts the first note there. Turning it off leaves
a round of one note, the one the interval lands on, which is quicker to get through.

Intervals and levels come from the ear trainer, `IntervalType` and
`getIntervalsForLevel()`, so a level means the same set of intervals in both. `Custom`
swaps the level stepper for chips, one per interval.

- `IntervalType.letterStep` says how many letter names the interval spans, which is what
  separates a minor third from an augmented second and spells the tritone as an
  augmented fourth: C to F#, Db to G.
- Descending counts the interval backwards from the root rather than reversing the two
  notes, so a major third below C is Ab.
- Mixed puts both directions in the pool and each round names its own under the title.
- The octave is left out. Pitch detection reports a pitch class and nothing else, so C
  up to C reads as one note held rather than two notes played.

## Harmony

`lib/core/harmony/` turns a key and a degree into a chord, which is what the four
harmony features all need and none of them owns.

- `scales.json` already gave every degree of every scale a roman numeral, a quality and
  a function. Only the function is read from it: the numeral and the quality are worked
  out by stacking thirds out of the scale, which is what gives seventh chords a numeral
  too. A test checks the derived triad numerals against the ones the file writes down.
- `chordAt(key, degree)` returns a `DiatonicChord`: the numeral, the chord symbol, the
  function and the notes, spelled from the key rather than from the pitch class, so the
  seventh degree of Eb major is Ddim and its notes are D F Ab.
- `keyAt(pitchClass, scale)` spells a key the way that scale needs it. Pitch class 1 is
  Db in major and C# in minor, both being the same key.
- `progressions.json` stores a progression as a scale and a run of degrees over it, with
  an optional `qualityId` per step. Degrees rather than chords is what lets one entry
  transpose to twelve keys; the override is what makes the blues dominant sevenths and
  gives the Andalusian cadence its major `V`.
- `voicing.dart` puts a chord on the keyboard: the root in the bass and the rest folded
  into the octave above middle C. Folding is what gives the voice leading, C major
  coming out C E G and F major C F A rather than an octave apart. Seventh chords drop
  the root from the upper voices, so a chord is never more than four notes and the
  playback service never needs more than four players.

## Progression trainer

The numerals are the headline, the key is the line under it, and the chord symbols are
never shown: working out which chords `I V vi IV` means in Db is the exercise. The user
plays the root of each chord in order, or every chord tone with `Arpeggiate the chords`
on, which turns a four chord progression into twelve notes.

## Roman numeral trainer

The only trainer that is answered by tapping rather than by playing. A round names a key
and asks one way or the other: `vi` in Eb, or `Cm` in Eb. The three distractors are
always other degrees of the same key, so a wrong answer is a chord that belonged.
`Seventh chords` stacks one degree further, `Hear the chord` plays the answer when it is
revealed.

## Harmony ear engine

The progression and cadence ear trainers are the same round over different questions, so
they run on one engine in `lib/core/harmony_ear/`. A feature supplies the answers on
offer and a function that draws the next question, and gets the phases, the score and
the answer buttons from the engine.

- The key changes every round. Recognising `I V vi IV` only counts if it survives being
  moved, so the answers are roman numerals and never chord names.
- Cadences open on the tonic. Two chords do not say what key they are in, and without a
  key a cadence is only an interval between two roots.
- The minor side of the cadence trainer uses harmonic minor, the scale that gives a
  cadence the major `V` it needs.
- Once the answer is in, the result shows the key and every chord with its numeral,
  which is the part that teaches.

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
