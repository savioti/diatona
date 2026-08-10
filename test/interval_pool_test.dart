import 'package:diatona/core/sequence_trainer/domain/note_sequence.dart';
import 'package:diatona/core/sequence_trainer/domain/sequence_direction.dart';
import 'package:diatona/features/ear_trainer/domain/interval_type.dart';
import 'package:diatona/features/interval_trainer/data/interval_pool.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

List<NoteSequence> pool(
  List<IntervalType> types, {
  SequenceDirection direction = SequenceDirection.ascending,
  bool naturalRootsOnly = true,
  bool playRoot = true,
}) =>
    buildIntervalPool(
      types,
      direction,
      title: (type, root) => '$root ${type.shortLabel}',
      directionLabel: (descending) => descending ? 'down' : 'up',
      naturalRootsOnly: naturalRootsOnly,
      playRoot: playRoot,
    );

void main() {
  test('a round is the root and the note the interval away', () {
    final cMajThird = byTitle(pool([IntervalType.majThird]), 'C M3');

    expect(cMajThird.noteNames, ['C', 'E']);
    expect(cMajThird.pitchClasses, [0, 4]);
    // The root is named in the title, so its slot is never blanked out.
    expect(cMajThird.hiddenFrom, 1);
  });

  test('without the root a round is only the note it lands on', () {
    final cMajThird =
        byTitle(pool([IntervalType.majThird], playRoot: false), 'C M3');

    expect(cMajThird.noteNames, ['E']);
    expect(cMajThird.pitchClasses, [4]);
    // Nothing is handed over, so nothing is exempt from being hidden.
    expect(cMajThird.hiddenFrom, 0);
  });

  test('the root slot is given, the note it lands on is not', () {
    final withRoot = byTitle(pool([IntervalType.majThird]), 'C M3');
    expect(withRoot.isGiven(0), isTrue);
    expect(withRoot.isGiven(1), isFalse);

    final without =
        byTitle(pool([IntervalType.majThird], playRoot: false), 'C M3');
    expect(without.isGiven(0), isFalse);
  });

  test('the interval decides the letter, not the semitone count', () {
    expect(byTitle(pool([IntervalType.minThird]), 'C m3').noteNames,
        ['C', 'Eb']);
    expect(byTitle(pool([IntervalType.majSecond]), 'C M2').noteNames,
        ['C', 'D']);
    // A tritone is spelled as an augmented fourth, so it takes the F letter.
    expect(byTitle(pool([IntervalType.tritone]), 'C TT').noteNames,
        ['C', 'F#']);
    expect(byTitle(pool([IntervalType.tritone]), 'D TT').noteNames,
        ['D', 'G#']);
  });

  test('descending counts the interval backwards from the root', () {
    final down = pool(
      [IntervalType.majThird],
      direction: SequenceDirection.descending,
    );

    expect(byTitle(down, 'C M3').noteNames, ['C', 'Ab']);
    expect(byTitle(down, 'C M3').pitchClasses, [0, 8]);
    expect(byTitle(down, 'B M3').noteNames, ['B', 'G']);
  });

  test('mixed holds both directions and each round says which', () {
    final mixed = pool(
      [IntervalType.perfectFifth],
      direction: SequenceDirection.upAndDown,
    );

    // Seven natural roots, twice over.
    expect(mixed.length, 14);
    final cRounds = mixed.where((s) => s.title == 'C P5').toList();
    expect(cRounds.map((s) => s.noteNames.last), ['G', 'F']);
    expect(cRounds.map((s) => s.subtitle), ['up', 'down']);
  });

  test('a single direction needs no subtitle', () {
    expect(byTitle(pool([IntervalType.perfectFifth]), 'C P5').subtitle, isNull);
  });

  test('the key spelling with fewer accidentals wins', () {
    final all = pool([IntervalType.majThird], naturalRootsOnly: false);
    final fromPitchClassOne =
        all.firstWhere((s) => s.pitchClasses.first == 1);

    expect(fromPitchClassOne.noteNames, ['Db', 'F']);
    expect(all.length, 12);
  });

  test('the octave is left out, it cannot be heard as two notes', () {
    expect(playableIntervals.contains(IntervalType.octave), isFalse);
    expect(playableIntervals.length, 11);

    // Level 1 of the ear trainer is the fifth and the octave.
    expect(intervalsForLevel(1), [IntervalType.perfectFifth]);
    expect(intervalsForLevel(3).length, 3);
  });
}
