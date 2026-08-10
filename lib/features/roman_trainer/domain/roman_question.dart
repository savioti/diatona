import 'package:flutter/foundation.dart';

import '../../../core/harmony/domain/diatonic_chord.dart';
import '../../../core/harmony/domain/harmonic_key.dart';

/// Which way round the question runs.
enum RomanQuestionKind {
  /// `In Eb Major, what is vi?` The numeral is given, the chord is the answer.
  numeralToChord,

  /// `In D Major, what is Bm?` The chord is given, the numeral is the answer.
  chordToNumeral,
}

/// Both directions matter and they are not the same skill, so the drill can ask
/// one, the other, or take them as they come.
enum RomanDrillMode {
  numeralToChord,
  chordToNumeral,
  mixed;

  bool allows(RomanQuestionKind kind) =>
      this == RomanDrillMode.mixed ||
      (this == RomanDrillMode.numeralToChord &&
          kind == RomanQuestionKind.numeralToChord) ||
      (this == RomanDrillMode.chordToNumeral &&
          kind == RomanQuestionKind.chordToNumeral);
}

/// One question of the drill: a key, a chord in it, and the choices offered.
@immutable
class RomanQuestion {
  const RomanQuestion({
    required this.key,
    required this.kind,
    required this.answer,
    required this.options,
  });

  final HarmonicKey key;
  final RomanQuestionKind kind;
  final DiatonicChord answer;

  /// The answer and its distractors, already shuffled. The distractors are
  /// other degrees of the same key, so a wrong answer is always a chord that
  /// belongs, never one that was never in the running.
  final List<DiatonicChord> options;

  /// What the question shows.
  String get prompt => kind == RomanQuestionKind.numeralToChord
      ? answer.numeral
      : answer.symbol;

  /// What an option reads as, which is whichever half the prompt is not.
  String labelOf(DiatonicChord chord) =>
      kind == RomanQuestionKind.numeralToChord ? chord.symbol : chord.numeral;
}
