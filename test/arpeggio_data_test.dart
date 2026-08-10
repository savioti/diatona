import 'package:diatona/core/sequence_trainer/domain/note_sequence.dart';
import 'package:diatona/core/sequence_trainer/domain/sequence_direction.dart';
import 'package:diatona/features/arpeggio_trainer/data/arpeggio_data.dart';
import 'package:diatona/features/arpeggio_trainer/domain/arpeggio_inversion.dart';
import 'package:diatona/features/trainer/domain/chord_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

String _label(int inversion) => 'inversion $inversion';

List<NoteSequence> pool(
  int level, {
  ArpeggioInversion inversion = ArpeggioInversion.root,
  int octaves = 1,
  SequenceDirection direction = SequenceDirection.ascending,
  bool naturalRootsOnly = true,
}) =>
    buildArpeggioPoolSingle(level, direction,
        inversion: inversion,
        octaves: octaves,
        inversionLabel: _label,
        naturalRootsOnly: naturalRootsOnly);

// Levels match the chord trainer, so the quality of a level is its ChordType.
int levelOf(ChordType type) => ChordType.values.indexOf(type) + 1;

void main() {
  setUpAll(() {
    loadChordDataFromDisk();
    loadArpeggioDataFromDisk();
  });

  test('every chord quality is present in chord_qualities.json', () {
    expect(arpeggioData.keys.toSet(), ChordType.values.toSet());
  });

  test('a triad runs root, third, fifth, octave', () {
    final cMajor = byTitle(pool(levelOf(ChordType.major)), 'C');

    expect(cMajor.noteNames, ['C', 'E', 'G', 'C']);
    expect(cMajor.pitchClasses, [0, 4, 7, 0]);
  });

  test('chord tones are spelled in thirds, one letter apart is skipped', () {
    final cMaj7 = byTitle(pool(levelOf(ChordType.maj7)), 'Cmaj7');
    expect(cMaj7.noteNames, ['C', 'E', 'G', 'B', 'C']);

    // The formula of a diminished 7th calls for a doubly flattened seventh.
    final cDim7 = byTitle(pool(levelOf(ChordType.dim7)), 'Cdim7');
    expect(cDim7.noteNames, ['C', 'Eb', 'Gb', 'Bbb', 'C']);
  });

  test('a suspended chord keeps its fourth, it is not spelled in thirds', () {
    final cSus4 = byTitle(pool(levelOf(ChordType.sus)), 'Csus4');

    expect(cSus4.noteNames, ['C', 'F', 'G', 'C']);
    expect(cSus4.pitchClasses, [0, 5, 7, 0]);
  });

  test('inversions rotate the tones and close on the starting one', () {
    final first = byTitle(
      pool(levelOf(ChordType.maj7), inversion: ArpeggioInversion.first),
      'Cmaj7',
    );
    expect(first.noteNames, ['E', 'G', 'B', 'C', 'E']);
    expect(first.pitchClasses, [4, 7, 11, 0, 4]);
    expect(first.subtitle, 'inversion 1');

    final second = byTitle(
      pool(levelOf(ChordType.major), inversion: ArpeggioInversion.second),
      'C',
    );
    expect(second.noteNames, ['G', 'C', 'E', 'G']);
  });

  test('root position has no inversion subtitle', () {
    expect(byTitle(pool(levelOf(ChordType.major)), 'C').subtitle, isNull);
  });

  test('random brings every inversion of the chord into the pool', () {
    final triads =
        pool(levelOf(ChordType.major), inversion: ArpeggioInversion.random);
    final sevenths =
        pool(levelOf(ChordType.maj7), inversion: ArpeggioInversion.random);

    // Seven natural roots, three tones in a triad and four in a seventh chord.
    expect(triads.length, 21);
    expect(sevenths.length, 28);
    expect(
      sevenths.where((s) => s.title == 'Cmaj7').map((s) => s.noteNames.first),
      ['C', 'E', 'G', 'B'],
    );
  });

  test('two octaves repeat the run before closing', () {
    final cMajor = byTitle(pool(levelOf(ChordType.major), octaves: 2), 'C');

    expect(cMajor.noteNames, ['C', 'E', 'G', 'C', 'E', 'G', 'C']);
    expect(cMajor.pitchClasses, [0, 4, 7, 0, 4, 7, 0]);
  });

  test('descending reverses the run', () {
    final cMajor = byTitle(
      pool(levelOf(ChordType.major), direction: SequenceDirection.descending),
      'C',
    );

    expect(cMajor.noteNames, ['C', 'G', 'E', 'C']);
  });

  test('cumulative pools follow the chord trainer levels', () {
    final level2 = buildArpeggioPool(2, SequenceDirection.ascending,
        inversion: ArpeggioInversion.root, octaves: 1, inversionLabel: _label);

    // Major and minor, seven natural roots each.
    expect(level2.length, 14);
    expect(byTitle(level2, 'Cm').noteNames, ['C', 'Eb', 'G', 'C']);
  });

  test('all keys brings the accidental roots in', () {
    final all = pool(levelOf(ChordType.major), naturalRootsOnly: false);

    expect(all.length, 12);
    expect(byTitle(all, 'C#').noteNames, ['C#', 'E#', 'G#', 'C#']);
  });
}
