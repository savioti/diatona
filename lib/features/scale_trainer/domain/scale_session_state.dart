import 'package:flutter/foundation.dart';

import 'scale_direction.dart';
import 'scale_item.dart';

/// Wrong notes allowed per scale before the trainer moves on.
const int kScaleMaxMisses = 3;

@immutable
class ScaleSessionState {
  const ScaleSessionState({
    required this.isActive,
    required this.isGetReady,
    required this.level,
    required this.timeLimitSeconds,
    required this.direction,
    this.currentScale,
    this.noteIndex = 0,
    this.misses = 0,
    this.showSuccess = false,
    this.showSkip = false,
    this.showMissed = false,
  });

  const ScaleSessionState.idle()
      : isActive = false,
        isGetReady = false,
        level = 1,
        timeLimitSeconds = 0,
        direction = ScaleDirection.ascending,
        currentScale = null,
        noteIndex = 0,
        misses = 0,
        showSuccess = false,
        showSkip = false,
        showMissed = false;

  final bool isActive;
  final bool isGetReady;
  final int level;
  final int timeLimitSeconds;
  final ScaleDirection direction;
  final ScaleItem? currentScale;

  /// How many notes of [currentScale] have been played so far.
  final int noteIndex;

  /// Wrong notes played on [currentScale], reset with every new scale.
  final int misses;

  final bool showSuccess;

  /// True for ~600 ms after the user skips a scale, triggering the skip overlay.
  final bool showSkip;

  /// True for ~1200 ms after the third wrong note, revealing the right answer.
  final bool showMissed;

  ScaleSessionState copyWith({
    bool? isActive,
    bool? isGetReady,
    int? level,
    int? timeLimitSeconds,
    ScaleDirection? direction,
    ScaleItem? currentScale,
    int? noteIndex,
    int? misses,
    bool? showSuccess,
    bool? showSkip,
    bool? showMissed,
  }) {
    return ScaleSessionState(
      isActive: isActive ?? this.isActive,
      isGetReady: isGetReady ?? this.isGetReady,
      level: level ?? this.level,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
      direction: direction ?? this.direction,
      currentScale: currentScale ?? this.currentScale,
      noteIndex: noteIndex ?? this.noteIndex,
      misses: misses ?? this.misses,
      showSuccess: showSuccess ?? this.showSuccess,
      showSkip: showSkip ?? this.showSkip,
      showMissed: showMissed ?? this.showMissed,
    );
  }
}
