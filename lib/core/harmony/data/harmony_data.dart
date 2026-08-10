import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../features/scale_trainer/data/scale_data.dart';
import '../../../features/scale_trainer/domain/scale_type.dart';
import '../../sequence_trainer/data/note_spelling.dart';
import '../../sequence_trainer/domain/note_degree.dart';
import '../domain/chord_quality.dart';
import '../domain/diatonic_chord.dart';
import '../domain/harmonic_function.dart';
import '../domain/harmonic_key.dart';

/// What each degree of each scale does, filled by [initHarmonyData].
///
/// Only the function is kept. The roman numeral and the quality are worked out
/// from the scale itself by [chordAt], which is what lets a seventh chord have
/// a numeral even though `scales.json` only names triads.
Map<ScaleType, List<HarmonicFunction>> scaleFunctionData = {};

/// Every chord quality by id, filled by [initHarmonyData].
Map<String, ChordQuality> chordQualityData = {};

const _numerals = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII'];

Future<void> initHarmonyData() async {
  final scalesRaw =
      await rootBundle.loadString('database/trainer/scales.json');
  final qualitiesRaw =
      await rootBundle.loadString('database/trainer/chord_qualities.json');

  loadHarmonyData(
    scales: jsonDecode(scalesRaw) as List<dynamic>,
    qualities: jsonDecode(qualitiesRaw) as List<dynamic>,
  );
}

/// Fills the maps from already decoded JSON, so that tests can hand it the
/// files from disk instead of going through the asset bundle.
void loadHarmonyData({
  required List<dynamic> scales,
  required List<dynamic> qualities,
}) {
  final byId = {for (final t in ScaleType.values) t.id: t};

  final functions = <ScaleType, List<HarmonicFunction>>{};
  for (final entry in scales) {
    final type = byId[entry['id'] as String];
    final degrees = entry['degrees'] as List<dynamic>?;
    if (type == null || degrees == null) continue;
    functions[type] = [
      for (final degree in degrees)
        HarmonicFunction.fromId(degree['function'] as String),
    ];
  }
  scaleFunctionData = functions;

  final loaded = <String, ChordQuality>{};
  for (final entry in qualities) {
    final formula = (entry['formula'] as List<dynamic>).cast<String>();
    final semitones = (entry['semitones'] as List<dynamic>).cast<int>();
    if (formula.length != semitones.length) continue;
    final id = entry['id'] as String;
    loaded[id] = ChordQuality(
      id: id,
      symbolSuffix: entry['shortName'] as String,
      semitones: List.unmodifiable(semitones),
      degrees: List.unmodifiable([
        for (var i = 0; i < formula.length; i++)
          NoteDegree(_letterStepOf(formula[i]), semitones[i]),
      ]),
    );
  }
  chordQualityData = loaded;
}

/// `b3` is a third, two letters above the root; `bb7` is a seventh, six above.
int _letterStepOf(String formulaDegree) {
  final digits = formulaDegree.replaceAll(RegExp(r'[^0-9]'), '');
  return (int.tryParse(digits) ?? 1) - 1;
}

/// The seven notes of [key], spelled one letter per degree.
List<String> keyNotes(HarmonicKey key) =>
    spell(key.root, _scaleDegreesOf(key.scale));

/// The key a pitch class names in [scale], spelled the way that scale needs.
/// Pitch class 1 is Db in major and C# in minor, both being the same key.
HarmonicKey keyAt(int pitchClass, ScaleType scale) => HarmonicKey(
      bestRootSpelling(
        rootSpellings[pitchClass % 12],
        _scaleDegreesOf(scale),
      ),
      scale,
    );

/// Every key of [scale], each spelled the way that needs fewest accidentals.
///
/// With [naturalRootsOnly] the seven keys without an accidental in the tonic,
/// otherwise all twelve.
List<HarmonicKey> harmonicKeys(
  ScaleType scale, {
  bool naturalRootsOnly = true,
}) =>
    naturalRootsOnly
        ? [for (final root in naturalRoots) HarmonicKey(root, scale)]
        : [for (var pc = 0; pc < 12; pc++) keyAt(pc, scale)];

/// The chord sitting on [degree] of [key], 1 for the tonic chord.
///
/// The quality comes from stacking thirds out of the scale, unless [qualityId]
/// overrides it. [sevenths] stacks one third further.
DiatonicChord chordAt(
  HarmonicKey key,
  int degree, {
  String? qualityId,
  bool sevenths = false,
}) {
  final index = (degree - 1) % 7;
  final root = keyNotes(key)[index];
  final id = qualityId ?? qualityIdAt(key.scale, degree, sevenths: sevenths);
  final quality = chordQualityData[id]!;
  final functions = scaleFunctionData[key.scale];

  return DiatonicChord(
    degree: index + 1,
    numeral: numeralFor(index + 1, quality),
    symbol: '$root${quality.symbolSuffix}',
    root: root,
    function: functions == null
        ? HarmonicFunction.tonic
        : functions[index % functions.length],
    qualityId: id,
    noteNames: spell(root, quality.degrees),
    pitchClasses: pitchClassesOf(root, quality.degrees),
  );
}

/// All seven chords of [key], the chart the other harmony features read from.
List<DiatonicChord> buildDiatonicChords(
  HarmonicKey key, {
  bool sevenths = false,
}) =>
    [for (var d = 1; d <= 7; d++) chordAt(key, d, sevenths: sevenths)];

/// Which quality a stack of scale notes on [degree] comes out as.
///
/// Stacking thirds out of the scale is what makes the fifth degree of the major
/// scale a major chord and the seventh a diminished one, without either being
/// written down anywhere.
String qualityIdAt(ScaleType scale, int degree, {bool sevenths = false}) {
  final semitones = scaleData[scale];
  if (semitones == null || semitones.length < 7) return 'quality_major';

  final index = (degree - 1) % 7;
  final steps = sevenths ? [0, 2, 4, 6] : [0, 2, 4];
  final signature = [
    for (final step in steps)
      (semitones[(index + step) % 7] - semitones[index]) % 12,
  ];

  for (final quality in chordQualityData.values) {
    if (_sameSignature(quality.semitones, signature)) return quality.id;
  }
  // Nothing in chord_qualities.json matches, which only happens if the scale
  // data grows past the twelve qualities. The triad is the safer fallback.
  return sevenths
      ? qualityIdAt(scale, degree)
      : 'quality_major';
}

bool _sameSignature(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] % 12 != b[i] % 12) return false;
  }
  return true;
}

/// `ii`, `V7`, `vii°`: the degree in roman numerals, cased and suffixed by the
/// quality. Lower case already says minor, so `m7` becomes `i7`.
String numeralFor(int degree, ChordQuality quality) {
  final base = _numerals[(degree - 1) % 7];
  return (quality.isMinorNumeral ? base.toLowerCase() : base) +
      quality.numeralSuffix;
}

List<NoteDegree> _scaleDegreesOf(ScaleType scale) {
  final semitones = scaleData[scale] ?? const [0, 2, 4, 5, 7, 9, 11];
  return [
    for (var i = 0; i < semitones.length; i++) NoteDegree(i, semitones[i]),
  ];
}
