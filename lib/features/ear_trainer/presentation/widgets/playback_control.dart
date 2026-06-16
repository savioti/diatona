import 'package:flutter/material.dart';

import '../../domain/ear_training_session_state.dart';

class PlaybackControl extends StatelessWidget {
  const PlaybackControl({
    super.key,
    required this.phase,
    required this.onPlay,
  });

  final EarTrainingPhase phase;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPlaying = phase == EarTrainingPhase.playing;
    final label = isPlaying ? 'Playing…' : 'Replay';
    final icon = isPlaying ? Icons.music_note_rounded : Icons.replay_rounded;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        key: ValueKey(isPlaying),
        width: double.infinity,
        height: 52,
        child: OutlinedButton.icon(
          onPressed: isPlaying ? null : onPlay,
          icon: Icon(icon),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            side: BorderSide(color: theme.colorScheme.primary.withAlpha(120)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
