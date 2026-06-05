import 'package:flutter/material.dart';

import '../../../trainer/presentation/widgets/staff_notation_painter.dart';
import '../../domain/note_clef.dart';
import '../../domain/note_item.dart';

class NoteDisplay extends StatelessWidget {
  const NoteDisplay({
    super.key,
    required this.note,
    required this.clef,
    required this.isGetReady,
    required this.getReadyText,
  });

  final NoteItem? note;
  final NoteClef clef;
  final bool isGetReady;
  final String getReadyText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: screenHeight * 0.4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        ),
        child: isGetReady
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
            : _buildStaff(note, clef),
      ),
    );
  }

  Widget _buildStaff(NoteItem? note, NoteClef clef) {
    if (note == null) return const SizedBox.shrink();
    final isTreble = clef == NoteClef.trebleClef;
    return Padding(
      key: ValueKey(note.id),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: SizedBox(
        width: double.infinity,
        height: 170,
        child: StaffNotationWidget(notes: [note.staffNote], isTreble: isTreble),
      ),
    );
  }
}
