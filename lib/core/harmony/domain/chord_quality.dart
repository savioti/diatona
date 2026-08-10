import 'package:flutter/foundation.dart';

import '../../sequence_trainer/domain/note_degree.dart';

/// A chord quality as the harmony features need it: what to add to a root note
/// to name the chord, and which tones it is made of.
///
/// Filled from `chord_qualities.json`, where [symbolSuffix] is `shortName` and
/// [degrees] comes from the formula, the same reading the arpeggio trainer does.
@immutable
class ChordQuality {
  const ChordQuality({
    required this.id,
    required this.symbolSuffix,
    required this.degrees,
    required this.semitones,
  });

  /// Matches the `id` field in `chord_qualities.json`, e.g. `quality_m7`.
  final String id;

  /// What follows the root in the chord symbol: `''`, `m`, `dim`, `m7b5`.
  final String symbolSuffix;

  final List<NoteDegree> degrees;

  /// Semitones above the root, the signature a stack of scale notes is
  /// identified by.
  final List<int> semitones;

  int get toneCount => degrees.length;

  /// Suffix the roman numeral takes, and whether the numeral is upper case.
  ///
  /// Numerals do not follow the chord symbol: a minor seventh is `m7` as a
  /// symbol but `i7` as a numeral, the lower case already saying it is minor.
  bool get isMinorNumeral => switch (id) {
        'quality_minor' ||
        'quality_dim' ||
        'quality_m7' ||
        'quality_dim7' ||
        'quality_halfdim7' ||
        'quality_mmaj7' =>
          true,
        _ => false,
      };

  String get numeralSuffix => switch (id) {
        'quality_aug' => '+',
        'quality_dim' => '°',
        'quality_sus4' => 'sus4',
        'quality_seventh' || 'quality_m7' => '7',
        'quality_maj7' => 'maj7',
        'quality_dim7' => '°7',
        'quality_halfdim7' => 'ø7',
        'quality_mmaj7' => '(maj7)',
        'quality_augmaj7' => '+maj7',
        _ => '',
      };
}
