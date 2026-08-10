import 'dart:math';

import 'package:diatona/features/roman_trainer/data/roman_questions.dart';
import 'package:diatona/features/roman_trainer/domain/roman_question.dart';
import 'package:diatona/features/scale_trainer/domain/scale_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

RomanDrillConfig _config({
  RomanDrillMode mode = RomanDrillMode.numeralToChord,
  bool sevenths = false,
  List<ScaleType> scales = const [ScaleType.major],
}) =>
    RomanDrillConfig(
      scales: scales,
      mode: mode,
      sevenths: sevenths,
      naturalRootsOnly: true,
      hearChord: false,
    );

void main() {
  setUpAll(() {
    loadScaleDataFromDisk();
    loadHarmonyDataFromDisk();
  });

  test('a question offers four choices, one of them right', () {
    final random = Random(7);

    for (var i = 0; i < 50; i++) {
      final question = buildRomanQuestion(_config(), random);

      expect(question.options.length, kRomanOptionCount);
      expect(question.options, contains(question.answer));
      expect(
        question.options.map(question.labelOf).toSet().length,
        kRomanOptionCount,
        reason: 'two choices read the same',
      );
    }
  });

  test('the distractors are other degrees of the same key', () {
    final question = buildRomanQuestion(_config(), Random(3));
    final degrees = question.options.map((chord) => chord.degree).toSet();

    expect(degrees.length, kRomanOptionCount);
    for (final chord in question.options) {
      expect(chord.symbol, startsWith(chord.root));
    }
  });

  test('the prompt is whichever half the choices are not', () {
    final toChord = buildRomanQuestion(_config(), Random(1));
    expect(toChord.prompt, toChord.answer.numeral);
    expect(toChord.labelOf(toChord.answer), toChord.answer.symbol);

    final toNumeral = buildRomanQuestion(
      _config(mode: RomanDrillMode.chordToNumeral),
      Random(1),
    );
    expect(toNumeral.prompt, toNumeral.answer.symbol);
    expect(toNumeral.labelOf(toNumeral.answer), toNumeral.answer.numeral);
  });

  test('the same chord is not asked twice in a row', () {
    final random = Random(11);
    var previous = buildRomanQuestion(_config(), random);

    for (var i = 0; i < 50; i++) {
      final next = buildRomanQuestion(_config(), random, previous: previous);
      expect(next.answer, isNot(previous.answer));
      previous = next;
    }
  });

  test('sevenths ask for seventh chords', () {
    final question = buildRomanQuestion(_config(sevenths: true), Random(5));

    expect(question.answer.noteNames.length, 4);
  });

  test('mixed draws both directions', () {
    final random = Random(2);
    final kinds = {
      for (var i = 0; i < 40; i++)
        buildRomanQuestion(_config(mode: RomanDrillMode.mixed), random).kind,
    };

    expect(kinds, RomanQuestionKind.values.toSet());
  });
}
