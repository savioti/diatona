import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../core/harmony/data/harmony_data.dart';
import '../../../core/harmony/domain/diatonic_chord.dart';
import '../../scale_trainer/domain/scale_type.dart';
import '../domain/roman_question.dart';

/// How many chords a question offers, the answer included.
const int kRomanOptionCount = 4;

/// Everything the drill needs to make its next question.
@immutable
class RomanDrillConfig {
  const RomanDrillConfig({
    required this.scales,
    required this.mode,
    required this.sevenths,
    required this.naturalRootsOnly,
    required this.hearChord,
  });

  final List<ScaleType> scales;
  final RomanDrillMode mode;
  final bool sevenths;
  final bool naturalRootsOnly;

  /// Plays the chord when the answer is revealed, which is what turns a naming
  /// exercise back into a musical one.
  final bool hearChord;
}

/// A question drawn at random, avoiding the chord [previous] already asked.
RomanQuestion buildRomanQuestion(
  RomanDrillConfig config,
  Random random, {
  RomanQuestion? previous,
}) {
  final scale = config.scales[random.nextInt(config.scales.length)];
  final keys = harmonicKeys(scale, naturalRootsOnly: config.naturalRootsOnly);
  final key = keys[random.nextInt(keys.length)];
  final chords = buildDiatonicChords(key, sevenths: config.sevenths);

  final candidates = previous == null
      ? chords
      : chords.where((chord) => chord != previous.answer).toList();
  final pickFrom = candidates.isEmpty ? chords : candidates;
  final answer = pickFrom[random.nextInt(pickFrom.length)];

  final distractors = chords.where((chord) => chord != answer).toList()
    ..shuffle(random);
  final options = [
    answer,
    ...distractors.take(kRomanOptionCount - 1),
  ]..shuffle(random);

  return RomanQuestion(
    key: key,
    kind: _pickKind(config.mode, random),
    answer: answer,
    options: options,
  );
}

RomanQuestionKind _pickKind(RomanDrillMode mode, Random random) =>
    switch (mode) {
      RomanDrillMode.numeralToChord => RomanQuestionKind.numeralToChord,
      RomanDrillMode.chordToNumeral => RomanQuestionKind.chordToNumeral,
      RomanDrillMode.mixed =>
        RomanQuestionKind.values[random.nextInt(RomanQuestionKind.values.length)],
    };

/// The notes of [chord], for the line shown under a revealed answer.
String chordNotesLabel(DiatonicChord chord) => chord.noteNames.join(' ');
