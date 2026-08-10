import '../domain/diatonic_chord.dart';

/// Bass register, one octave of it, so the root always lands on a sample the
/// piano has.
const _bassBase = 48; // C3

/// Where the upper voices live, again one octave wide.
const _upperBase = 60; // C4

/// The most notes a voicing uses, and so the number of players the playback
/// service has to keep around.
const int kVoiceCount = 4;

/// MIDI notes for [chord]: the root in the bass, the rest of the chord packed
/// into the octave above middle C.
///
/// Folding every upper voice into one octave is what gives the voice leading
/// for free. C major comes out C E G and F major comes out C F A, the two
/// chords sharing a register rather than jumping an octave apart.
///
/// Seventh chords drop the root from the upper voices, so that a chord is never
/// more than [kVoiceCount] notes.
List<int> voiceChord(DiatonicChord chord) {
  final pitchClasses = chord.pitchClasses;
  if (pitchClasses.isEmpty) return const [];

  final upper = pitchClasses.length >= kVoiceCount
      ? pitchClasses.skip(1)
      : pitchClasses;

  return [
    _bassBase + pitchClasses.first,
    for (final pitchClass in upper) _upperBase + pitchClass,
  ];
}

List<List<int>> voiceProgression(List<DiatonicChord> chords) =>
    [for (final chord in chords) voiceChord(chord)];
