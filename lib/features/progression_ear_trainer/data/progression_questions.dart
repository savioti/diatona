import 'dart:math';

import '../../../core/harmony/data/harmony_data.dart';
import '../../../core/harmony/data/progression_data.dart';
import '../../../core/harmony/domain/chord_progression.dart';
import '../../../core/harmony/domain/harmonic_key.dart';
import '../../../core/harmony_ear/domain/harmony_ear_question.dart';

/// One answer per progression in the pool, named by its numerals. The name is
/// left out on purpose: `I V vi IV` is what is being learnt, `Axis` is trivia.
List<HarmonyEarChoice> progressionChoices(List<ChordProgression> pool) => [
      for (final progression in pool)
        HarmonyEarChoice(
          id: progression.id,
          label: progressionNumerals(progression).join(' '),
        ),
    ];

/// A progression from [pool] in a key drawn at random.
///
/// A new key every round is the point: recognising `I V vi IV` only counts if
/// it survives being moved.
HarmonyEarQuestion buildProgressionQuestion(
  List<ChordProgression> pool,
  Random random, {
  required bool naturalRootsOnly,
  required String Function(HarmonicKey key) keyLabel,
  HarmonyEarQuestion? previous,
}) {
  ChordProgression progression;
  do {
    progression = pool[random.nextInt(pool.length)];
  } while (pool.length > 1 && progression.id == previous?.choiceId);

  final keys = harmonicKeys(
    progression.scale,
    naturalRootsOnly: naturalRootsOnly,
  );
  final key = keys[random.nextInt(keys.length)];

  return HarmonyEarQuestion(
    choiceId: progression.id,
    chords: realizeProgression(progression, key.root),
    keyLabel: keyLabel(key),
  );
}
