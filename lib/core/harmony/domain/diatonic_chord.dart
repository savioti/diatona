import 'package:flutter/foundation.dart';

import 'harmonic_function.dart';

/// A degree of a key, worked out into an actual chord.
///
/// The same degree is a different chord in every key, and the same chord is a
/// different degree in every key. Both halves live here so that a screen can
/// show one and ask for the other.
@immutable
class DiatonicChord {
  const DiatonicChord({
    required this.degree,
    required this.numeral,
    required this.symbol,
    required this.root,
    required this.function,
    required this.qualityId,
    required this.noteNames,
    required this.pitchClasses,
  });

  /// Where the chord sits in the scale, 1 to 7.
  final int degree;

  /// `ii`, `V7`, `vii°`: the degree and the quality, without the key.
  final String numeral;

  /// `Dm`, `G7`, `Bdim`: the chord as it is written on a chart.
  final String symbol;

  /// Spelled root of the chord, `Bb` rather than `A#`.
  final String root;

  final HarmonicFunction function;

  /// Matches the `id` field in `chord_qualities.json`.
  final String qualityId;

  final List<String> noteNames;
  final List<int> pitchClasses;

  @override
  bool operator ==(Object other) =>
      other is DiatonicChord &&
      other.symbol == symbol &&
      other.numeral == numeral;

  @override
  int get hashCode => Object.hash(symbol, numeral);

  @override
  String toString() => '$numeral ($symbol)';
}
