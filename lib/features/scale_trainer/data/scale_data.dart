import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/scale_direction.dart';
import '../domain/scale_item.dart';
import '../domain/scale_type.dart';

const _letters = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
const _letterPitchClasses = [0, 2, 4, 5, 7, 9, 11];

/// Sharp spellings, the only ones the pitch detection service ever emits.
const _detectedNames = [
  'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B',
];

const _naturalRoots = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];

/// Root spellings per pitch class, flat first. Pitch classes with two options
/// are resolved per scale by [_bestRoot], which keeps the accidental count down.
const _rootSpellings = <List<String>>[
  ['C'],
  ['Db', 'C#'],
  ['D'],
  ['Eb', 'D#'],
  ['E'],
  ['F'],
  ['Gb', 'F#'],
  ['G'],
  ['Ab', 'G#'],
  ['A'],
  ['Bb', 'A#'],
  ['B'],
];

/// Semitone offsets of every scale type, filled by [initScaleData].
Map<ScaleType, List<int>> scaleData = {};

Future<void> initScaleData() async {
  final raw = await rootBundle.loadString('database/trainer/scales.json');
  final list = jsonDecode(raw) as List<dynamic>;
  final byId = {for (final t in ScaleType.values) t.id: t};

  final loaded = <ScaleType, List<int>>{};
  for (final entry in list) {
    final type = byId[entry['id'] as String];
    if (type == null) continue;
    loaded[type] = (entry['semitones'] as List<dynamic>).cast<int>();
  }

  scaleData = loaded;
}

/// Pitch class of a note name emitted by the pitch detector, null if unknown.
int? pitchClassOfDetectedNote(String name) {
  final index = _detectedNames.indexOf(name);
  return index >= 0 ? index : null;
}

/// Cumulative pool: every scale type from level 1 up to [level], in every key.
List<ScaleItem> buildScalePool(
  int level,
  ScaleDirection direction, {
  bool naturalRootsOnly = true,
}) =>
    _buildPool(_typesUpTo(level), direction, naturalRootsOnly);

/// Single-level pool: only the scale type belonging to exactly [level].
List<ScaleItem> buildScalePoolSingle(
  int level,
  ScaleDirection direction, {
  bool naturalRootsOnly = true,
}) =>
    _buildPool([_typeAt(level)], direction, naturalRootsOnly);

List<ScaleType> _typesUpTo(int level) =>
    ScaleType.values.take(level.clamp(1, ScaleType.values.length)).toList();

ScaleType _typeAt(int level) =>
    ScaleType.values[(level - 1).clamp(0, ScaleType.values.length - 1)];

List<ScaleItem> _buildPool(
  List<ScaleType> types,
  ScaleDirection direction,
  bool naturalRootsOnly,
) {
  final pool = <ScaleItem>[];
  for (final type in types) {
    final semitones = scaleData[type];
    if (semitones == null) continue;
    final roots = naturalRootsOnly
        ? _naturalRoots
        : [for (final options in _rootSpellings) _bestRoot(options, semitones)];
    for (final root in roots) {
      pool.add(_buildItem(type, root, semitones, direction));
    }
  }
  return List.unmodifiable(pool);
}

ScaleItem _buildItem(
  ScaleType type,
  String root,
  List<int> semitones,
  ScaleDirection direction,
) {
  // The closing octave repeats the root, so it is part of what the user plays.
  final degrees = [...semitones, 12];
  final rootPitchClass = _pitchClassOf(root);

  return ScaleItem(
    type: type,
    rootName: root,
    noteNames: _ordered(_spell(root, degrees), direction),
    pitchClasses: _ordered(
      [for (final s in degrees) (rootPitchClass + s) % 12],
      direction,
    ),
  );
}

List<T> _ordered<T>(List<T> ascending, ScaleDirection direction) =>
    switch (direction) {
      ScaleDirection.ascending => ascending,
      ScaleDirection.descending => ascending.reversed.toList(),
      // The top note is played once, then the scale comes back down.
      ScaleDirection.upAndDown => [
          ...ascending,
          ...ascending.reversed.skip(1),
        ],
    };

/// Names the [degrees] of a scale using one letter per degree, so a seven note
/// scale always reads A to G once, e.g. Bb Dorian as Bb C Db Eb F G Ab.
List<String> _spell(String root, List<int> degrees) {
  final rootLetter = _letters.indexOf(root[0]);
  final rootPitchClass = _pitchClassOf(root);

  return [
    for (var i = 0; i < degrees.length; i++)
      _degreeName(rootLetter, rootPitchClass, i, degrees[i]),
  ];
}

String _degreeName(
  int rootLetter,
  int rootPitchClass,
  int step,
  int semitone,
) {
  final letter = (rootLetter + step) % 7;
  var alteration =
      (rootPitchClass + semitone - _letterPitchClasses[letter]) % 12;
  if (alteration > 6) alteration -= 12;
  return _letters[letter] + _accidental(alteration);
}

String _accidental(int alteration) =>
    (alteration > 0 ? '#' : 'b') * alteration.abs();

int _pitchClassOf(String name) {
  var value = _letterPitchClasses[_letters.indexOf(name[0])];
  for (final char in name.substring(1).split('')) {
    value += char == '#' ? 1 : -1;
  }
  return value % 12;
}

/// Of two spellings of the same key, the one that needs fewer accidentals.
/// C# Locrian beats Db Locrian, Db Major beats C# Major.
String _bestRoot(List<String> options, List<int> semitones) {
  var best = options.first;
  var bestCost = _accidentalCost(best, semitones);
  for (final option in options.skip(1)) {
    final cost = _accidentalCost(option, semitones);
    if (cost < bestCost) {
      best = option;
      bestCost = cost;
    }
  }
  return best;
}

int _accidentalCost(String root, List<int> semitones) =>
    _spell(root, semitones).fold(0, (sum, name) => sum + name.length - 1);
