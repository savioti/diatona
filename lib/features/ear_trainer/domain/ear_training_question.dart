import 'interval_direction.dart';
import 'interval_type.dart';

class EarTrainingQuestion {
  const EarTrainingQuestion({
    required this.firstMidi,
    required this.secondMidi,
    required this.interval,
    required this.direction,
  });

  /// MIDI number of the first note played.
  final int firstMidi;

  /// MIDI number of the second note played.
  final int secondMidi;

  final IntervalType interval;

  /// Resolved direction — never [IntervalDirection.random].
  final IntervalDirection direction;
}
