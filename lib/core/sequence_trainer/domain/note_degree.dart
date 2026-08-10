import 'package:flutter/foundation.dart';

/// One note of a sequence, described relative to the root.
///
/// [letterStep] is how many letter names above the root the note sits, so 0 for
/// the root, 2 for a third, 7 for the octave. [semitone] is the distance in
/// semitones. Together they name the note: a third that is 3 semitones up from
/// C is Eb, one that is 4 semitones up is E.
@immutable
class NoteDegree {
  const NoteDegree(this.letterStep, this.semitone);

  final int letterStep;
  final int semitone;

  NoteDegree get octaveUp => NoteDegree(letterStep + 7, semitone + 12);
}
