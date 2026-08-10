import 'package:diatona/core/sequence_trainer/domain/note_sequence.dart';
import 'package:diatona/core/sequence_trainer/domain/sequence_direction.dart';
import 'package:diatona/features/scale_trainer/data/scale_data.dart';
import 'package:diatona/features/scale_trainer/domain/scale_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

String _title(ScaleType type, String root) => '$root ${type.name}';

List<NoteSequence> pool(
  int level,
  SequenceDirection direction, {
  bool naturalRootsOnly = true,
}) =>
    buildScalePool(level, direction,
        title: _title, naturalRootsOnly: naturalRootsOnly);

void main() {
  setUpAll(loadScaleDataFromDisk);

  test('every scale type is present in scales.json', () {
    expect(scaleData.keys.toSet(), ScaleType.values.toSet());
  });

  test('scales close the octave', () {
    final cMajor = byTitle(pool(1, SequenceDirection.ascending), 'C major');

    expect(cMajor.noteNames, ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'C']);
    expect(cMajor.pitchClasses, [0, 2, 4, 5, 7, 9, 11, 0]);
  });

  test('descending reverses the scale, up and down turns at the octave', () {
    final down = byTitle(pool(1, SequenceDirection.descending), 'C major');
    expect(down.noteNames, ['C', 'B', 'A', 'G', 'F', 'E', 'D', 'C']);

    final upDown = byTitle(pool(1, SequenceDirection.upAndDown), 'C major');
    expect(upDown.noteNames.length, 15);
    expect(upDown.noteNames.sublist(5, 9), ['A', 'B', 'C', 'B']);
  });

  test('each degree uses its own letter', () {
    final all = pool(
      ScaleType.values.length,
      SequenceDirection.ascending,
      naturalRootsOnly: false,
    );

    for (final scale in all) {
      final letters = scale.noteNames.take(7).map((n) => n[0]).toSet();
      expect(letters.length, 7, reason: scale.title);
    }
  });

  test('the key spelling with fewer accidentals wins', () {
    final all = pool(
      ScaleType.values.length,
      SequenceDirection.ascending,
      naturalRootsOnly: false,
    );
    String rootOf(ScaleType type) => all
        .firstWhere((s) =>
            s.title.endsWith(type.name) && s.pitchClasses.first == 1)
        .noteNames
        .first;

    expect(rootOf(ScaleType.major), 'Db');
    expect(rootOf(ScaleType.locrian), 'C#');
  });

  test('a flat key stays flat all the way through', () {
    final bbDorian = byTitle(
      pool(3, SequenceDirection.ascending, naturalRootsOnly: false),
      'Bb dorian',
    );

    expect(bbDorian.noteNames, ['Bb', 'C', 'Db', 'Eb', 'F', 'G', 'Ab', 'Bb']);
  });

  test('cumulative pools grow by one scale type per level', () {
    expect(pool(1, SequenceDirection.ascending).length, 7);
    expect(pool(3, SequenceDirection.ascending).length, 21);
    expect(
      buildScalePoolSingle(3, SequenceDirection.ascending, title: _title)
          .every((s) => s.title.endsWith('dorian')),
      isTrue,
    );
  });
}
