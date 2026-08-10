import 'package:flutter/foundation.dart';

import '../../../features/scale_trainer/domain/scale_type.dart';

/// One chord of a progression, named by where it sits rather than by what it
/// is, so the progression transposes to any key.
///
/// [qualityId] overrides what the scale would give, which is what turns the
/// blues into dominant sevenths and the Andalusian cadence's `v` into a `V`.
@immutable
class ProgressionStep {
  const ProgressionStep(this.degree, [this.qualityId]);

  final int degree;
  final String? qualityId;

  factory ProgressionStep.fromJson(Map<String, dynamic> json) =>
      ProgressionStep(json['degree'] as int, json['qualityId'] as String?);
}

/// A progression as `progressions.json` stores it: a scale and a run of degrees
/// over it. Nothing here names a key, that arrives when the progression is
/// realized.
@immutable
class ChordProgression {
  const ChordProgression({
    required this.id,
    required this.name,
    required this.scale,
    required this.steps,
    required this.tags,
  });

  final String id;

  /// English name of the progression, `Axis`, `Andalusian Cadence`. The roman
  /// numerals are what identifies it on screen, the name only labels it.
  final String name;

  final ScaleType scale;
  final List<ProgressionStep> steps;
  final List<String> tags;

  bool get isMinor => tags.contains('minor');

  int get length => steps.length;

  @override
  bool operator ==(Object other) =>
      other is ChordProgression && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
