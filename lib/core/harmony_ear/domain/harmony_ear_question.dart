import 'package:flutter/foundation.dart';

import '../../harmony/domain/diatonic_chord.dart';

/// One of the answers a round offers.
///
/// The label is what the button reads, the id is what the question points at,
/// so a progression and a cadence can both be answered the same way.
@immutable
class HarmonyEarChoice {
  const HarmonyEarChoice({required this.id, required this.label});

  final String id;
  final String label;

  @override
  bool operator ==(Object other) => other is HarmonyEarChoice && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// A run of chords to play and the choice that names them.
@immutable
class HarmonyEarQuestion {
  const HarmonyEarQuestion({
    required this.choiceId,
    required this.chords,
    required this.keyLabel,
  });

  final String choiceId;

  /// What is played, already in the key the round drew.
  final List<DiatonicChord> chords;

  /// `Eb Major`, shown once the answer is in. Before that it would give the
  /// chords away.
  final String keyLabel;
}
