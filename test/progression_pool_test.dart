import 'package:diatona/core/harmony/data/progression_data.dart';
import 'package:diatona/core/sequence_trainer/domain/note_sequence.dart';
import 'package:diatona/features/progression_trainer/data/progression_pool.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

List<NoteSequence> _pool(
  String progressionId, {
  bool naturalRootsOnly = true,
  bool arpeggiate = false,
}) =>
    buildProgressionPool(
      [progressionById(progressionId)!],
      keyLabel: (key) => '${key.root} ${key.scale.name}',
      naturalRootsOnly: naturalRootsOnly,
      arpeggiate: arpeggiate,
    );

void main() {
  setUpAll(() {
    loadScaleDataFromDisk();
    loadHarmonyDataFromDisk();
    loadProgressionDataFromDisk();
  });

  test('a round asks for the root of each chord in order', () {
    final round = byTitle(_pool('prog_axis'), 'I  V  vi  IV');

    // The key is C, so the roots are C G A F.
    final inC = _pool('prog_axis').firstWhere((s) => s.subtitle!.startsWith('C '));
    expect(inC.noteNames, ['C', 'G', 'A', 'F']);
    expect(inC.pitchClasses, [0, 7, 9, 5]);
    expect(round.hiddenFrom, 0);
  });

  test('the chords are never named, only the numerals and the key', () {
    final round = _pool('prog_axis').first;

    expect(round.title, 'I  V  vi  IV');
    expect(round.subtitle, isNotNull);
    expect(round.title, isNot(contains('m')));
  });

  test('arpeggiating asks for every tone of every chord', () {
    final inC =
        _pool('prog_axis', arpeggiate: true).firstWhere((s) => s.subtitle!.startsWith('C '));

    expect(inC.noteNames, [
      'C', 'E', 'G', //
      'G', 'B', 'D', //
      'A', 'C', 'E', //
      'F', 'A', 'C', //
    ]);
    expect(inC.length, 12);
  });

  test('natural roots give seven rounds and all keys give twelve', () {
    expect(_pool('prog_axis').length, 7);
    expect(_pool('prog_axis', naturalRootsOnly: false).length, 12);
  });

  test('a minor progression draws its keys from its own scale', () {
    final rounds = _pool('prog_andalusian', naturalRootsOnly: false);

    expect(rounds.length, 12);
    expect(
      rounds.map((s) => s.title).toSet(),
      {'i  VII  VI  V'},
    );
  });
}
