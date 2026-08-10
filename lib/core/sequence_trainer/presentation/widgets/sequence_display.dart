import 'package:flutter/material.dart';

import '../../domain/note_sequence.dart';
import '../../domain/sequence_session_state.dart';

/// Shows what to play and fills the notes in as they are played.
///
/// With [showNames] off the notes stay hidden until the user plays them, so the
/// title is all there is to go on.
class SequenceDisplay extends StatelessWidget {
  const SequenceDisplay({
    super.key,
    required this.sequence,
    required this.noteIndex,
    required this.misses,
    required this.showNames,
    required this.isGetReady,
    required this.getReadyText,
    required this.hintText,
  });

  final NoteSequence? sequence;

  /// How many notes have been played, so [noteIndex] is the one to play next.
  final int noteIndex;

  /// Wrong notes played on this round so far.
  final int misses;

  final bool showNames;
  final bool isGetReady;
  final String getReadyText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: Alignment.center,
      // Up and down runs reach fifteen notes, more than a short screen fits.
      child: SingleChildScrollView(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
          child: isGetReady || sequence == null
              ? Text(
                  key: const ValueKey('ready'),
                  getReadyText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    letterSpacing: 2,
                  ),
                )
              : _buildSequence(sequence!, colorScheme),
        ),
      ),
    );
  }

  Widget _buildSequence(NoteSequence sequence, ColorScheme colorScheme) {
    return Padding(
      key: ValueKey(sequence.id),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            sequence.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          if (sequence.subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              sequence.subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.85),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            hintText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          _MissTracker(misses: misses, colorScheme: colorScheme),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < sequence.noteNames.length; i++)
                _NoteChip(
                  name: sequence.noteNames[i],
                  played: i < noteIndex,
                  isNext: i == noteIndex,
                  hidden: !showNames && i >= noteIndex,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MissTracker extends StatelessWidget {
  const _MissTracker({required this.misses, required this.colorScheme});

  final int misses;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < kSequenceMaxMisses; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              i < misses ? Icons.close_rounded : Icons.circle_outlined,
              size: 16,
              color: i < misses
                  ? colorScheme.error
                  : colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
            ),
          ),
      ],
    );
  }
}

class _NoteChip extends StatelessWidget {
  const _NoteChip({
    required this.name,
    required this.played,
    required this.isNext,
    required this.hidden,
  });

  final String name;
  final bool played;
  final bool isNext;

  /// Blanks out the name, leaving only the slot the note will land in.
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final background = played
        ? colorScheme.primary
        : colorScheme.onPrimaryContainer.withValues(alpha: 0.08);
    final foreground = played
        ? colorScheme.onPrimary
        : colorScheme.onPrimaryContainer.withValues(alpha: isNext ? 1.0 : 0.5);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNext ? colorScheme.tertiary : Colors.transparent,
          width: 2,
        ),
      ),
      child: SizedBox(
        width: 30,
        child: Text(
          hidden ? '?' : name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: foreground,
          ),
        ),
      ),
    );
  }
}
