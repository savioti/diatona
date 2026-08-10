import 'package:diatona/core/audio/piano_sample.dart';
import 'package:diatona/core/harmony/data/harmony_data.dart';
import 'package:diatona/core/harmony/data/voicing.dart';
import 'package:diatona/core/harmony/domain/harmonic_key.dart';
import 'package:diatona/features/scale_trainer/domain/scale_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  setUpAll(() {
    loadScaleDataFromDisk();
    loadHarmonyDataFromDisk();
  });

  test('a triad is the root in the bass and the three tones above it', () {
    final chords = buildDiatonicChords(const HarmonicKey('C', ScaleType.major));

    // C3, then C4 E4 G4.
    expect(voiceChord(chords[0]), [48, 60, 64, 67]);
  });

  test('the upper voices stay inside one octave, so the chords lead', () {
    final chords = buildDiatonicChords(const HarmonicKey('C', ScaleType.major));

    // F major folds back to C F A rather than climbing away from C major.
    expect(voiceChord(chords[3]), [53, 65, 69, 60]);
  });

  test('a seventh chord drops the root from the upper voices', () {
    final chords = buildDiatonicChords(
      const HarmonicKey('C', ScaleType.major),
      sevenths: true,
    );

    // G3, then B4 D4 F4: four notes, one per player.
    expect(voiceChord(chords[4]), [55, 71, 62, 65]);
  });

  test('every chord of every key fits the samples and the players', () {
    for (final scale in ScaleType.values) {
      for (final key in harmonicKeys(scale, naturalRootsOnly: false)) {
        for (final sevenths in [false, true]) {
          for (final chord in buildDiatonicChords(key, sevenths: sevenths)) {
            final notes = voiceChord(chord);
            expect(notes.length, lessThanOrEqualTo(kVoiceCount));
            for (final note in notes) {
              expect(note, inInclusiveRange(kPianoMidiMin, kPianoMidiMax));
            }
          }
        }
      }
    }
  });
}
