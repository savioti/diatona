import 'package:flutter/foundation.dart';

import 'note_clef.dart';
import 'note_item.dart';

@immutable
class NoteSessionState {
  const NoteSessionState({
    required this.isActive,
    required this.isGetReady,
    required this.level,
    required this.timeLimitSeconds,
    required this.clef,
    this.currentNote,
    this.showSuccess = false,
    this.showSkip = false,
  });

  const NoteSessionState.idle()
      : isActive = false,
        isGetReady = false,
        level = 1,
        timeLimitSeconds = 3,
        clef = NoteClef.trebleClef,
        currentNote = null,
        showSuccess = false,
        showSkip = false;

  final bool isActive;
  final bool isGetReady;
  final int level;
  final int timeLimitSeconds;
  final NoteClef clef;
  final NoteItem? currentNote;
  final bool showSuccess;

  /// True for ~600 ms after the user skips a note, triggering the skip overlay.
  final bool showSkip;

  NoteSessionState copyWith({
    bool? isActive,
    bool? isGetReady,
    int? level,
    int? timeLimitSeconds,
    NoteClef? clef,
    NoteItem? currentNote,
    bool? showSuccess,
    bool? showSkip,
    bool clearNote = false,
  }) {
    return NoteSessionState(
      isActive: isActive ?? this.isActive,
      isGetReady: isGetReady ?? this.isGetReady,
      level: level ?? this.level,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
      clef: clef ?? this.clef,
      currentNote: clearNote ? null : (currentNote ?? this.currentNote),
      showSuccess: showSuccess ?? this.showSuccess,
      showSkip: showSkip ?? this.showSkip,
    );
  }
}
