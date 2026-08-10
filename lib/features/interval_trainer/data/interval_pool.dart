import '../../../core/sequence_trainer/data/note_spelling.dart';
import '../../../core/sequence_trainer/domain/note_degree.dart';
import '../../../core/sequence_trainer/domain/note_sequence.dart';
import '../../../core/sequence_trainer/domain/sequence_direction.dart';
import '../../ear_trainer/data/interval_levels.dart';
import '../../ear_trainer/domain/interval_type.dart';

/// The octave is left out of this trainer. Pitch detection reports a pitch
/// class and nothing else, so C up to C reads as one note held, which no amount
/// of listening can tell apart from the interval being played.
final List<IntervalType> playableIntervals = List.unmodifiable(
  IntervalType.values.where((t) => t != IntervalType.octave),
);

/// The levels of the ear trainer, minus the intervals this one cannot hear.
List<IntervalType> intervalsForLevel(int level) => getIntervalsForLevel(level)
    .where(playableIntervals.contains)
    .toList();

/// Every interval in [types], from every key.
///
/// A round is the root and the note the interval away from it, or only the note
/// it lands on when [playRoot] is off.
///
/// [SequenceDirection.upAndDown] means mixed here: both directions land in the
/// pool and each round says which one it wants.
List<NoteSequence> buildIntervalPool(
  List<IntervalType> types,
  SequenceDirection direction, {
  required String Function(IntervalType type, String root) title,
  required String Function(bool descending) directionLabel,
  bool naturalRootsOnly = true,
  bool playRoot = true,
}) {
  final descents = switch (direction) {
    SequenceDirection.ascending => [false],
    SequenceDirection.descending => [true],
    SequenceDirection.upAndDown => [false, true],
  };
  final mixed = descents.length > 1;

  final pool = <NoteSequence>[];
  for (final type in types) {
    for (final descending in descents) {
      final degrees = _degreesOf(type, descending, playRoot);
      final roots = naturalRootsOnly
          ? naturalRoots
          : [
              for (final options in rootSpellings)
                bestRootSpelling(options, degrees),
            ];
      for (final root in roots) {
        pool.add(NoteSequence(
          id: '${type.name}_${root}_$descending',
          title: title(type, root),
          subtitle: mixed ? directionLabel(descending) : null,
          noteNames: spell(root, degrees),
          pitchClasses: pitchClassesOf(root, degrees),
          // The root is in the title, hiding its slot would fool nobody.
          hiddenFrom: playRoot ? 1 : 0,
        ));
      }
    }
  }
  return List.unmodifiable(pool);
}

/// The root, then the note the interval away from it. Going down is the same
/// interval counted backwards, so a major third below C is Ab.
List<NoteDegree> _degreesOf(
  IntervalType type,
  bool descending,
  bool playRoot,
) =>
    [
      if (playRoot) const NoteDegree(0, 0),
      descending
          ? NoteDegree(-type.letterStep, -type.semitones)
          : NoteDegree(type.letterStep, type.semitones),
    ];
