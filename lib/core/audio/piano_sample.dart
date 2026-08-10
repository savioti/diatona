// Where the piano samples live and what they are called. Shared by everything
// that plays a note, so that the range and the file naming are written down
// once.

import 'package:audioplayers/audioplayers.dart';

// Flat-notation names matching the asset filenames.
const _noteNames = [
  'C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B',
];

/// MIDI range covered by the samples: C3 to B5.
const int kPianoMidiMin = 48;
const int kPianoMidiMax = 83;

/// Asset path of a MIDI note, in the form audioplayers expects.
String pianoAssetPath(int midi) =>
    'instrument_sounds/piano/piano_mf_${pianoNoteName(midi)}.mp3';

/// Human readable name of a MIDI note, e.g. `C4`, `Db5`.
String pianoNoteName(int midi) =>
    '${_noteNames[midi % 12]}${midi ~/ 12 - 1}';

/// Copies every sample out of the asset bundle, ahead of the first note.
///
/// audioplayers reads an asset from the bundle and writes it to a temp file the
/// first time that asset is played, and the note only sounds once the copy is
/// done. Left to happen mid-round, that is what made the opening chords of a
/// session land late, out of order, or not at all, while every replay after
/// them was clean.
///
/// The cache is global to the app and outlives any one screen, so this is paid
/// once and covers every trainer.
Future<void> warmPianoSamples() async {
  try {
    await AudioCache.instance.loadAll([
      for (var midi = kPianoMidiMin; midi <= kPianoMidiMax; midi++)
        pianoAssetPath(midi),
    ]);
  } catch (_) {
    // Warming is an optimisation, not a requirement: a sample that fails here
    // is loaded again on its first play, the way it was before.
  }
}
