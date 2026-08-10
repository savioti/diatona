import '../domain/note_degree.dart';
import '../domain/sequence_direction.dart';

const _letters = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
const _letterPitchClasses = [0, 2, 4, 5, 7, 9, 11];

/// Sharp spellings, the only ones the pitch detection service ever emits.
const _detectedNames = [
  'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B',
];

/// The seven roots without an accidental.
const naturalRoots = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];

/// Root spellings per pitch class, flat first. Pitch classes with two options
/// are resolved per sequence by [bestRootSpelling].
const rootSpellings = <List<String>>[
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

/// Pitch class of a note name emitted by the pitch detector, null if unknown.
int? pitchClassOfDetectedNote(String name) {
  final index = _detectedNames.indexOf(name);
  return index >= 0 ? index : null;
}

/// Pitch class of a spelled note name such as `Bb` or `F##`.
int pitchClassOfNote(String name) {
  var value = _letterPitchClasses[_letters.indexOf(name[0])];
  for (final char in name.substring(1).split('')) {
    value += char == '#' ? 1 : -1;
  }
  return value % 12;
}

/// Names every degree by the letter it belongs to, so a scale reads A to G once
/// and a chord reads in thirds: `Bb Dorian` gives Bb C Db Eb F G Ab, `Cdim7`
/// gives C Eb Gb Bbb.
List<String> spell(String root, List<NoteDegree> degrees) {
  final rootLetter = _letters.indexOf(root[0]);
  final rootPitchClass = pitchClassOfNote(root);

  return [
    for (final degree in degrees)
      _degreeName(rootLetter, rootPitchClass, degree),
  ];
}

List<int> pitchClassesOf(String root, List<NoteDegree> degrees) {
  final rootPitchClass = pitchClassOfNote(root);
  return [for (final d in degrees) (rootPitchClass + d.semitone) % 12];
}

String _degreeName(int rootLetter, int rootPitchClass, NoteDegree degree) {
  final letter = (rootLetter + degree.letterStep) % 7;
  var alteration =
      (rootPitchClass + degree.semitone - _letterPitchClasses[letter]) % 12;
  if (alteration > 6) alteration -= 12;
  return _letters[letter] + _accidental(alteration);
}

String _accidental(int alteration) =>
    (alteration > 0 ? '#' : 'b') * alteration.abs();

/// Of two spellings of the same key, the one that needs fewer accidentals.
/// C# Locrian beats Db Locrian, Db Major beats C# Major.
String bestRootSpelling(List<String> options, List<NoteDegree> degrees) {
  var best = options.first;
  var bestCost = _accidentalCost(best, degrees);
  for (final option in options.skip(1)) {
    final cost = _accidentalCost(option, degrees);
    if (cost < bestCost) {
      best = option;
      bestCost = cost;
    }
  }
  return best;
}

int _accidentalCost(String root, List<NoteDegree> degrees) =>
    spell(root, degrees).fold(0, (sum, name) => sum + name.length - 1);

List<T> orderedForDirection<T>(
  List<T> ascending,
  SequenceDirection direction,
) =>
    switch (direction) {
      SequenceDirection.ascending => ascending,
      SequenceDirection.descending => ascending.reversed.toList(),
      // The top note is played once, then the run comes back down.
      SequenceDirection.upAndDown => [
          ...ascending,
          ...ascending.reversed.skip(1),
        ],
    };
