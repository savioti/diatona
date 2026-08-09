import 'dart:convert';
import 'dart:io';

import 'package:diatona/features/scale_trainer/data/scale_data.dart';
import 'package:diatona/features/scale_trainer/domain/scale_direction.dart';
import 'package:diatona/features/scale_trainer/domain/scale_item.dart';
import 'package:diatona/features/scale_trainer/domain/scale_type.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reads the same file the app bundles, without going through rootBundle.
void loadScalesFromDisk() {
  final raw = File('database/trainer/scales.json').readAsStringSync();
  final list = jsonDecode(raw) as List<dynamic>;
  final byId = {for (final t in ScaleType.values) t.id: t};

  scaleData = {
    for (final entry in list)
      if (byId[entry['id'] as String] != null)
        byId[entry['id'] as String]!:
            (entry['semitones'] as List<dynamic>).cast<int>(),
  };
}

ScaleItem scaleOf(List<ScaleItem> pool, String root, ScaleType type) =>
    pool.firstWhere((s) => s.rootName == root && s.type == type);

void main() {
  setUpAll(loadScalesFromDisk);

  test('every scale type is present in scales.json', () {
    expect(scaleData.keys.toSet(), ScaleType.values.toSet());
  });

  test('scales close the octave', () {
    final pool = buildScalePool(1, ScaleDirection.ascending);
    final cMajor = scaleOf(pool, 'C', ScaleType.major);

    expect(cMajor.noteNames, ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'C']);
    expect(cMajor.pitchClasses, [0, 2, 4, 5, 7, 9, 11, 0]);
  });

  test('descending reverses the scale, up and down turns at the octave', () {
    final down = scaleOf(
      buildScalePool(1, ScaleDirection.descending),
      'C',
      ScaleType.major,
    );
    expect(down.noteNames, ['C', 'B', 'A', 'G', 'F', 'E', 'D', 'C']);

    final upDown = scaleOf(
      buildScalePool(1, ScaleDirection.upAndDown),
      'C',
      ScaleType.major,
    );
    expect(upDown.noteNames.length, 15);
    expect(upDown.noteNames.sublist(5, 9), ['A', 'B', 'C', 'B']);
  });

  test('each degree uses its own letter', () {
    final pool = buildScalePool(
      ScaleType.values.length,
      ScaleDirection.ascending,
      naturalRootsOnly: false,
    );

    for (final scale in pool) {
      final letters = scale.noteNames.take(7).map((n) => n[0]).toSet();
      expect(letters.length, 7, reason: '${scale.rootName} ${scale.type.name}');
    }
  });

  test('the key spelling with fewer accidentals wins', () {
    String rootFor(ScaleType type) => buildScalePool(
          ScaleType.values.length,
          ScaleDirection.ascending,
          naturalRootsOnly: false,
        ).firstWhere((s) => s.type == type && s.pitchClasses.first == 1).rootName;

    expect(rootFor(ScaleType.major), 'Db');
    expect(rootFor(ScaleType.locrian), 'C#');
  });

  test('a flat key stays flat all the way through', () {
    final pool =
        buildScalePool(3, ScaleDirection.ascending, naturalRootsOnly: false);
    final bbDorian = scaleOf(pool, 'Bb', ScaleType.dorian);

    expect(bbDorian.noteNames, ['Bb', 'C', 'Db', 'Eb', 'F', 'G', 'Ab', 'Bb']);
  });

  test('cumulative pools grow by one scale type per level', () {
    final level1 = buildScalePool(1, ScaleDirection.ascending);
    final level3 = buildScalePool(3, ScaleDirection.ascending);

    expect(level1.length, 7);
    expect(level3.length, 21);
    expect(
      buildScalePoolSingle(3, ScaleDirection.ascending)
          .every((s) => s.type == ScaleType.dorian),
      isTrue,
    );
  });

  test('detected note names map back to pitch classes', () {
    expect(pitchClassOfDetectedNote('C'), 0);
    expect(pitchClassOfDetectedNote('A#'), 10);
    expect(pitchClassOfDetectedNote('Db'), isNull);
  });
}
