import 'package:flutter/foundation.dart';

/// A run of notes to play, already laid out in the order they are expected.
///
/// Scales, arpeggios and intervals all come down to this: something to call it,
/// the note names to show, and the pitch classes to listen for.
@immutable
class NoteSequence {
  const NoteSequence({
    required this.id,
    required this.title,
    required this.noteNames,
    required this.pitchClasses,
    this.subtitle,
    this.hiddenFrom = 0,
  });

  /// Identity for the picker that spreads rounds over the pool.
  final String id;

  /// What the training screen shows, e.g. `Bb Dorian` or `Cmaj7`.
  final String title;

  /// Smaller line under [title], used for the inversion of an arpeggio. It says
  /// where to start without naming the note.
  final String? subtitle;

  final List<String> noteNames;

  /// Pitch classes matching [noteNames], compared against detected pitches.
  final List<int> pitchClasses;

  /// Notes before this index are named even when the rest are hidden. Interval
  /// rounds use it for the starting note, which the title gives away anyway.
  final int hiddenFrom;

  int get length => pitchClasses.length;

  /// Whether the note at [index] is one the round hands over rather than asks
  /// for. Fumbling one of those costs nothing, the screen already named it.
  bool isGiven(int index) => index < hiddenFrom;

  @override
  bool operator ==(Object other) => other is NoteSequence && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
