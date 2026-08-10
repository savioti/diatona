import 'package:diatona/core/harmony/data/progression_data.dart';
import 'package:diatona/core/harmony/domain/cadence_type.dart';
import 'package:diatona/core/harmony/domain/harmonic_key.dart';
import 'package:diatona/features/scale_trainer/domain/scale_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

List<String> _symbols(String progressionId, String root) =>
    realizeProgression(progressionById(progressionId)!, root)
        .map((chord) => chord.symbol)
        .toList();

void main() {
  setUpAll(() {
    loadScaleDataFromDisk();
    loadHarmonyDataFromDisk();
    loadProgressionDataFromDisk();
  });

  test('every progression in the file loads with a scale and steps', () {
    expect(progressionData, isNotEmpty);
    for (final progression in progressionData) {
      expect(progression.steps, isNotEmpty);
      expect(progression.name, isNotEmpty);
    }
  });

  test('a progression is the same degrees in every key', () {
    expect(_symbols('prog_axis', 'C'), ['C', 'G', 'Am', 'F']);
    expect(_symbols('prog_axis', 'Eb'), ['Eb', 'Bb', 'Cm', 'Ab']);
  });

  test('the numerals do not depend on the key', () {
    final progression = progressionById('prog_axis')!;

    expect(progressionNumerals(progression), ['I', 'V', 'vi', 'IV']);
    expect(
      realizeProgression(progression, 'F#').map((c) => c.numeral),
      progressionNumerals(progression),
    );
  });

  test('a quality override beats what the scale would give', () {
    // The blues is dominant sevenths throughout, where the major scale would
    // have given a plain triad on I and IV.
    expect(_symbols('prog_blues_twelve_bar', 'C').take(2), ['C7', 'F7']);

    // The Andalusian cadence lands on a major V that natural minor does not
    // have.
    expect(_symbols('prog_andalusian', 'A'), ['Am', 'G', 'F', 'E']);
  });

  test('a minor progression is built on its own scale', () {
    expect(_symbols('prog_minor_two_five_one', 'C'), ['Dm7b5', 'G7', 'Cm']);
    expect(
      progressionNumerals(progressionById('prog_minor_two_five_one')!),
      ['iiø7', 'V7', 'i'],
    );
  });

  test('a cadence opens on the tonic and holds in major and minor', () {
    const major = HarmonicKey('C', ScaleType.major);
    const minor = HarmonicKey('A', ScaleType.harmonicMinor);

    expect(
      realizeCadence(CadenceType.authentic, major).map((c) => c.symbol),
      ['C', 'G', 'C'],
    );
    expect(
      realizeCadence(CadenceType.deceptive, major).map((c) => c.numeral),
      ['I', 'V', 'vi'],
    );
    expect(
      realizeCadence(CadenceType.plagal, minor).map((c) => c.symbol),
      ['Am', 'Dm', 'Am'],
    );
    // The half cadence is the one that stops on the dominant.
    expect(
      realizeCadence(CadenceType.half, minor).map((c) => c.symbol),
      ['Am', 'Dm', 'E'],
    );
  });
}
