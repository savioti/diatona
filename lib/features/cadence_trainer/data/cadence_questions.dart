import 'dart:math';

import '../../../core/harmony/data/harmony_data.dart';
import '../../../core/harmony/data/progression_data.dart';
import '../../../core/harmony/domain/cadence_type.dart';
import '../../../core/harmony/domain/harmonic_key.dart';
import '../../../core/harmony_ear/domain/harmony_ear_question.dart';
import '../../scale_trainer/domain/scale_type.dart';

/// Harmonic minor rather than natural minor: a cadence needs the major `V`,
/// which only the raised seventh gives.
const _minorScale = ScaleType.harmonicMinor;

List<HarmonyEarChoice> cadenceChoices(
  List<CadenceType> pool,
  String Function(CadenceType cadence) labelOf,
) =>
    [
      for (final cadence in pool)
        HarmonyEarChoice(id: cadence.name, label: labelOf(cadence)),
    ];

/// A cadence from [pool] in a key drawn at random, opening on the tonic so the
/// key is established before the cadence itself lands.
HarmonyEarQuestion buildCadenceQuestion(
  List<CadenceType> pool,
  Random random, {
  required bool includeMinor,
  required bool naturalRootsOnly,
  required String Function(HarmonicKey key) keyLabel,
  HarmonyEarQuestion? previous,
}) {
  CadenceType cadence;
  do {
    cadence = pool[random.nextInt(pool.length)];
  } while (pool.length > 1 && cadence.name == previous?.choiceId);

  final scale = includeMinor && random.nextBool()
      ? _minorScale
      : ScaleType.major;
  final keys = harmonicKeys(scale, naturalRootsOnly: naturalRootsOnly);
  final key = keys[random.nextInt(keys.length)];

  return HarmonyEarQuestion(
    choiceId: cadence.name,
    chords: realizeCadence(cadence, key),
    keyLabel: keyLabel(key),
  );
}
