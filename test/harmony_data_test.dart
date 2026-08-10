import 'dart:convert';
import 'dart:io';

import 'package:diatona/core/harmony/data/harmony_data.dart';
import 'package:diatona/core/harmony/domain/harmonic_function.dart';
import 'package:diatona/core/harmony/domain/harmonic_key.dart';
import 'package:diatona/features/scale_trainer/domain/scale_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

List<String> _numeralsOf(HarmonicKey key, {bool sevenths = false}) =>
    buildDiatonicChords(key, sevenths: sevenths)
        .map((chord) => chord.numeral)
        .toList();

List<String> _symbolsOf(HarmonicKey key, {bool sevenths = false}) =>
    buildDiatonicChords(key, sevenths: sevenths)
        .map((chord) => chord.symbol)
        .toList();

void main() {
  setUpAll(() {
    loadScaleDataFromDisk();
    loadHarmonyDataFromDisk();
  });

  test('every scale in scales.json carries its degree functions', () {
    expect(scaleFunctionData.keys.toSet(), ScaleType.values.toSet());
    for (final functions in scaleFunctionData.values) {
      expect(functions.length, 7);
    }
  });

  test('every chord quality is loaded with a symbol and a formula', () {
    expect(chordQualityData.length, 12);
    expect(chordQualityData['quality_m7']!.symbolSuffix, 'm7');
    expect(chordQualityData['quality_halfdim7']!.semitones, [0, 3, 6, 10]);
  });

  // The numerals are worked out from the scale rather than read from the file,
  // which is what gives seventh chords a numeral too. They still have to agree
  // with the ones the file names.
  test('derived triad numerals match the ones scales.json writes down', () {
    final scales =
        jsonDecode(File('database/trainer/scales.json').readAsStringSync())
            as List<dynamic>;
    final byId = {for (final t in ScaleType.values) t.id: t};

    for (final entry in scales) {
      final scale = byId[entry['id'] as String]!;
      final expected = [
        for (final degree in (entry['degrees'] as List<dynamic>))
          degree['romanNumeral'] as String,
      ];
      expect(
        _numeralsOf(HarmonicKey('C', scale)),
        expected,
        reason: 'numerals of ${scale.id}',
      );
    }
  });

  test('the major key gives its seven chords', () {
    const key = HarmonicKey('C', ScaleType.major);

    expect(_symbolsOf(key), ['C', 'Dm', 'Em', 'F', 'G', 'Am', 'Bdim']);
    expect(_numeralsOf(key), ['I', 'ii', 'iii', 'IV', 'V', 'vi', 'vii°']);
  });

  test('sevenths stack one third further', () {
    const key = HarmonicKey('C', ScaleType.major);

    expect(_symbolsOf(key, sevenths: true),
        ['Cmaj7', 'Dm7', 'Em7', 'Fmaj7', 'G7', 'Am7', 'Bm7b5']);
    expect(_numeralsOf(key, sevenths: true),
        ['Imaj7', 'ii7', 'iii7', 'IVmaj7', 'V7', 'vi7', 'viiø7']);
  });

  test('harmonic minor keeps the major fifth degree', () {
    const key = HarmonicKey('A', ScaleType.harmonicMinor);

    expect(_symbolsOf(key), ['Am', 'Bdim', 'Caug', 'Dm', 'E', 'F', 'G#dim']);
    expect(_symbolsOf(key, sevenths: true).elementAt(4), 'E7');
    expect(_numeralsOf(key, sevenths: true).elementAt(6), 'vii°7');
  });

  test('chords are spelled from the key, not from the pitch class', () {
    final chords = buildDiatonicChords(const HarmonicKey('Eb', ScaleType.major));

    expect(chords[1].symbol, 'Fm');
    expect(chords[1].noteNames, ['F', 'Ab', 'C']);
    expect(chords[6].symbol, 'Ddim');
    expect(chords[6].noteNames, ['D', 'F', 'Ab']);
  });

  test('a key is spelled the way its own scale needs it', () {
    // Db major takes five flats, C# major takes seven sharps.
    expect(keyAt(1, ScaleType.major).root, 'Db');
    // C# minor takes four sharps, Db minor takes eight flats.
    expect(keyAt(1, ScaleType.naturalMinor).root, 'C#');
  });

  test('degree functions come through on the chord', () {
    final chords = buildDiatonicChords(const HarmonicKey('C', ScaleType.major));

    expect(chords[0].function, HarmonicFunction.tonic);
    expect(chords[3].function, HarmonicFunction.subdominant);
    expect(chords[4].function, HarmonicFunction.dominant);
  });

  test('natural roots give seven keys and all keys give twelve', () {
    expect(harmonicKeys(ScaleType.major).length, 7);
    expect(harmonicKeys(ScaleType.major, naturalRootsOnly: false).length, 12);
  });
}
