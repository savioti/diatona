import 'package:flutter/foundation.dart';

import 'scale_type.dart';

/// One scale to play, already laid out in the order the user has to play it.
@immutable
class ScaleItem {
  const ScaleItem({
    required this.type,
    required this.rootName,
    required this.noteNames,
    required this.pitchClasses,
  });

  final ScaleType type;

  /// Spelled root, e.g. "Bb" or "F#".
  final String rootName;

  /// Spelled note names in play order, including the closing octave.
  final List<String> noteNames;

  /// Pitch classes matching [noteNames], compared against detected pitches.
  final List<int> pitchClasses;

  String get id => '${type.name}_$rootName';

  int get length => pitchClasses.length;

  @override
  bool operator ==(Object other) => other is ScaleItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
