import 'package:flutter/foundation.dart';

import 'chord.dart';

@immutable
class TrainingSessionState {
  const TrainingSessionState({
    required this.isActive,
    required this.isGetReady,
    required this.level,
    required this.timeLimitSeconds,
    this.currentChord,
    this.showSuccess = false,
    this.showSkip = false,
  });

  const TrainingSessionState.idle()
      : isActive = false,
        isGetReady = false,
        level = 1,
        timeLimitSeconds = 3,
        currentChord = null,
        showSuccess = false,
        showSkip = false;

  final bool isActive;

  /// True during the 2-second "Get Ready" phase before the first chord appears.
  final bool isGetReady;

  final int level;

  /// Seconds the user has to play each chord. 0 = no time limit.
  final int timeLimitSeconds;

  final Chord? currentChord;

  /// True for ~800 ms after a correct root note is detected, triggering the success overlay.
  final bool showSuccess;

  /// True for ~600 ms after the user skips a chord, triggering the skip overlay.
  final bool showSkip;

  TrainingSessionState copyWith({
    bool? isActive,
    bool? isGetReady,
    int? level,
    int? timeLimitSeconds,
    Chord? currentChord,
    bool? showSuccess,
    bool? showSkip,
    bool clearChord = false,
  }) {
    return TrainingSessionState(
      isActive: isActive ?? this.isActive,
      isGetReady: isGetReady ?? this.isGetReady,
      level: level ?? this.level,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
      currentChord: clearChord ? null : (currentChord ?? this.currentChord),
      showSuccess: showSuccess ?? this.showSuccess,
      showSkip: showSkip ?? this.showSkip,
    );
  }
}
