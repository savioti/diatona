import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

/// Plays the question again. Disabled while it is already sounding, so that a
/// second tap cannot start the audio over the top of itself.
class ReplayControl extends StatelessWidget {
  const ReplayControl({
    super.key,
    required this.isPlaying,
    required this.onPlay,
  });

  final bool isPlaying;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        key: ValueKey(isPlaying),
        width: double.infinity,
        height: 52,
        child: OutlinedButton.icon(
          onPressed: isPlaying ? null : onPlay,
          icon: Icon(
            isPlaying ? Icons.music_note_rounded : Icons.replay_rounded,
          ),
          label: Text(isPlaying ? l10n.playbackPlaying : l10n.playbackReplay),
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
