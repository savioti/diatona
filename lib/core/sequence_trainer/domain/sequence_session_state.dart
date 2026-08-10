import 'package:flutter/foundation.dart';

import 'note_sequence.dart';

/// Wrong notes allowed per round before the trainer moves on.
const int kSequenceMaxMisses = 3;

@immutable
class SequenceSessionState {
  const SequenceSessionState({
    required this.isActive,
    required this.isGetReady,
    required this.timeLimitSeconds,
    this.current,
    this.noteIndex = 0,
    this.misses = 0,
    this.showSuccess = false,
    this.showSkip = false,
    this.showMissed = false,
  });

  const SequenceSessionState.idle()
      : isActive = false,
        isGetReady = false,
        timeLimitSeconds = 0,
        current = null,
        noteIndex = 0,
        misses = 0,
        showSuccess = false,
        showSkip = false,
        showMissed = false;

  final bool isActive;
  final bool isGetReady;
  final int timeLimitSeconds;
  final NoteSequence? current;

  /// How many notes of [current] have been played so far.
  final int noteIndex;

  /// Wrong notes played on [current], reset with every new round.
  final int misses;

  final bool showSuccess;

  /// True for ~600 ms after the user skips a round, triggering the skip overlay.
  final bool showSkip;

  /// True for ~1200 ms after the third wrong note, revealing the right answer.
  final bool showMissed;

  SequenceSessionState copyWith({
    bool? isActive,
    bool? isGetReady,
    int? timeLimitSeconds,
    NoteSequence? current,
    int? noteIndex,
    int? misses,
    bool? showSuccess,
    bool? showSkip,
    bool? showMissed,
  }) {
    return SequenceSessionState(
      isActive: isActive ?? this.isActive,
      isGetReady: isGetReady ?? this.isGetReady,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
      current: current ?? this.current,
      noteIndex: noteIndex ?? this.noteIndex,
      misses: misses ?? this.misses,
      showSuccess: showSuccess ?? this.showSuccess,
      showSkip: showSkip ?? this.showSkip,
      showMissed: showMissed ?? this.showMissed,
    );
  }
}
