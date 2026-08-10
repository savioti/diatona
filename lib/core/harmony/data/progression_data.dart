import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../features/scale_trainer/domain/scale_type.dart';
import '../domain/cadence_type.dart';
import '../domain/chord_progression.dart';
import '../domain/diatonic_chord.dart';
import '../domain/harmonic_key.dart';
import 'harmony_data.dart';

/// Every progression in `progressions.json`, filled by [initProgressionData].
List<ChordProgression> progressionData = [];

Future<void> initProgressionData() async {
  final raw = await rootBundle.loadString('database/trainer/progressions.json');
  loadProgressionData(jsonDecode(raw) as Map<String, dynamic>);
}

/// Fills [progressionData] from already decoded JSON, so that tests can read
/// the file from disk instead of going through the asset bundle.
void loadProgressionData(Map<String, dynamic> json) {
  final byId = {for (final t in ScaleType.values) t.id: t};
  final loaded = <ChordProgression>[];

  for (final entry in (json['progressions'] as List<dynamic>)) {
    final scale = byId[entry['scaleId'] as String];
    if (scale == null) continue;
    loaded.add(ChordProgression(
      id: entry['id'] as String,
      name: entry['name'] as String,
      scale: scale,
      steps: [
        for (final step in (entry['steps'] as List<dynamic>))
          ProgressionStep.fromJson(step as Map<String, dynamic>),
      ],
      tags: (entry['tags'] as List<dynamic>).cast<String>(),
    ));
  }

  progressionData = List.unmodifiable(loaded);
}

ChordProgression? progressionById(String id) {
  for (final progression in progressionData) {
    if (progression.id == id) return progression;
  }
  return null;
}

/// The progression as actual chords in [root], the key being the only thing
/// `progressions.json` leaves out.
List<DiatonicChord> realizeProgression(
  ChordProgression progression,
  String root, {
  bool sevenths = false,
}) {
  final key = HarmonicKey(root, progression.scale);
  return [
    for (final step in progression.steps)
      chordAt(key, step.degree, qualityId: step.qualityId, sevenths: sevenths),
  ];
}

/// The roman numerals of a progression, which do not depend on the key. This is
/// what identifies a progression on screen, `I V vi IV` rather than its name.
List<String> progressionNumerals(
  ChordProgression progression, {
  bool sevenths = false,
}) =>
    // C is only a stand-in: every key gives the same numerals.
    realizeProgression(progression, 'C', sevenths: sevenths)
        .map((chord) => chord.numeral)
        .toList();

/// A cadence as chords in [key], opening on the tonic so that the key is heard
/// before the cadence itself arrives.
List<DiatonicChord> realizeCadence(CadenceType cadence, HarmonicKey key) =>
    [for (final degree in cadence.degrees) chordAt(key, degree)];
