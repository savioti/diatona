import '../../../core/harmony/data/harmony_data.dart';
import '../../../core/harmony/data/progression_data.dart';
import '../../../core/harmony/domain/chord_progression.dart';
import '../../../core/harmony/domain/harmonic_key.dart';
import '../../../core/sequence_trainer/domain/note_sequence.dart';

/// Every progression in [progressions], from every key.
///
/// The round shows the roman numerals and asks for the notes, so working out
/// which chords the numerals stand for in this key is the exercise. The chord
/// symbols are never shown: they are the answer.
///
/// With [arpeggiate] the round asks for every tone of every chord rather than
/// the roots alone, which is the same progression read as notes instead of as
/// a bass line.
List<NoteSequence> buildProgressionPool(
  List<ChordProgression> progressions, {
  required String Function(HarmonicKey key) keyLabel,
  bool naturalRootsOnly = true,
  bool arpeggiate = false,
}) {
  final pool = <NoteSequence>[];

  for (final progression in progressions) {
    for (final key in harmonicKeys(
      progression.scale,
      naturalRootsOnly: naturalRootsOnly,
    )) {
      final chords = realizeProgression(progression, key.root);
      pool.add(NoteSequence(
        id: '${progression.id}_${key.root}_$arpeggiate',
        // The numerals are what the round asks, so they are the headline and
        // the key is the smaller line under it.
        title: chords.map((chord) => chord.numeral).join('  '),
        subtitle: keyLabel(key),
        noteNames: [
          for (final chord in chords)
            if (arpeggiate) ...chord.noteNames else chord.root,
        ],
        pitchClasses: [
          for (final chord in chords)
            if (arpeggiate) ...chord.pitchClasses else chord.pitchClasses.first,
        ],
      ));
    }
  }

  return List.unmodifiable(pool);
}
