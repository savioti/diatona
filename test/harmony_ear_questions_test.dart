import 'dart:math';

import 'package:diatona/core/harmony/data/progression_data.dart';
import 'package:diatona/core/harmony/domain/cadence_type.dart';
import 'package:diatona/core/harmony/domain/harmonic_key.dart';
import 'package:diatona/core/harmony_ear/domain/harmony_ear_question.dart';
import 'package:diatona/features/cadence_trainer/data/cadence_questions.dart';
import 'package:diatona/features/progression_ear_trainer/data/progression_questions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

String _key(HarmonicKey key) => '${key.root} ${key.scale.name}';

void main() {
  setUpAll(() {
    loadScaleDataFromDisk();
    loadHarmonyDataFromDisk();
    loadProgressionDataFromDisk();
  });

  test('a progression choice is named by its numerals', () {
    final pool = [
      progressionById('prog_axis')!,
      progressionById('prog_two_five_one')!,
    ];

    expect(
      progressionChoices(pool).map((choice) => choice.label),
      ['I V vi IV', 'ii7 V7 Imaj7'],
    );
  });

  test('a progression question points at one of the choices', () {
    final pool = progressionData.take(4).toList();
    final ids = progressionChoices(pool).map((c) => c.id).toSet();
    final random = Random(4);

    HarmonyEarQuestion? previous;
    for (var i = 0; i < 40; i++) {
      final question = buildProgressionQuestion(
        pool,
        random,
        naturalRootsOnly: true,
        keyLabel: _key,
        previous: previous,
      );

      expect(ids, contains(question.choiceId));
      expect(question.chords, isNotEmpty);
      expect(question.choiceId, isNot(previous?.choiceId));
      previous = question;
    }
  });

  test('progression questions move around the keys', () {
    final pool = [progressionById('prog_axis')!];
    final random = Random(9);
    final keys = {
      for (var i = 0; i < 40; i++)
        buildProgressionQuestion(pool, random,
                naturalRootsOnly: true, keyLabel: _key)
            .keyLabel,
    };

    expect(keys.length, greaterThan(1));
  });

  test('a cadence question runs three chords and names the cadence', () {
    final random = Random(6);
    final choices =
        cadenceChoices(CadenceType.values, (cadence) => cadence.name);

    HarmonyEarQuestion? previous;
    for (var i = 0; i < 40; i++) {
      final question = buildCadenceQuestion(
        CadenceType.values,
        random,
        includeMinor: true,
        naturalRootsOnly: true,
        keyLabel: _key,
        previous: previous,
      );

      expect(question.chords.length, 3);
      expect(choices.map((c) => c.id), contains(question.choiceId));
      // The first chord is always the tonic, which is what sets the key.
      expect(question.chords.first.degree, 1);
      expect(question.choiceId, isNot(previous?.choiceId));
      previous = question;
    }
  });

  test('major only keeps every round in a major key', () {
    final random = Random(8);
    final scales = {
      for (var i = 0; i < 30; i++)
        buildCadenceQuestion(
          CadenceType.values,
          random,
          includeMinor: false,
          naturalRootsOnly: true,
          keyLabel: _key,
        ).keyLabel.split(' ').last,
    };

    expect(scales, {'major'});
  });
}
