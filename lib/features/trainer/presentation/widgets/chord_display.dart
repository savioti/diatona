import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/chord_database.dart';
import '../../data/providers.dart';
import '../../domain/chord.dart';
import '../../domain/chord_display_mode.dart';
import 'chord_diagram_painter.dart';
import 'staff_notation_painter.dart';

class ChordDisplay extends ConsumerWidget {
  const ChordDisplay({
    super.key,
    required this.chord,
    required this.isGetReady,
    required this.getReadyText,
  });

  final Chord? chord;
  final bool isGetReady;
  final String getReadyText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final mode = ref.watch(selectedDisplayModeProvider);

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
            : _buildChordContent(chord, mode),
      ),
    );
  }

  Widget _buildChordContent(Chord? chord, ChordDisplayMode mode) {
    return switch (mode) {
      ChordDisplayMode.symbol => _ChordLabel(
          key: ValueKey(chord?.symbol),
          chord: chord,
        ),
      ChordDisplayMode.trebleClef => _StaffContent(
          key: ValueKey('treble_${chord?.symbol}'),
          chord: chord,
          isTreble: true,
        ),
      ChordDisplayMode.bassClef => _StaffContent(
          key: ValueKey('bass_${chord?.symbol}'),
          chord: chord,
          isTreble: false,
        ),
      ChordDisplayMode.guitar => _DiagramContent(
          key: ValueKey('guitar_${chord?.symbol}'),
          chord: chord,
          instrument: 'guitar',
        ),
      ChordDisplayMode.ukulele => _DiagramContent(
          key: ValueKey('ukulele_${chord?.symbol}'),
          chord: chord,
          instrument: 'ukulele',
        ),
    };
  }
}

class _ChordLabel extends StatelessWidget {
  const _ChordLabel({super.key, required this.chord});

  final Chord? chord;

  @override
  Widget build(BuildContext context) {
    final symbol = chord?.symbol ?? '';
    final alt = chord?.altSymbol;
    const style = TextStyle(
      fontSize: 64,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 2,
    );
    const dividerStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w300,
      color: Colors.white54,
    );

    if (alt == null) {
      return Text(symbol, textAlign: TextAlign.center, style: style);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(symbol, textAlign: TextAlign.center, style: style),
        const Text('/', textAlign: TextAlign.center, style: dividerStyle),
        Text(alt, textAlign: TextAlign.center, style: style),
      ],
    );
  }
}

class _StaffContent extends StatelessWidget {
  const _StaffContent({
    super.key,
    required this.chord,
    required this.isTreble,
  });

  final Chord? chord;
  final bool isTreble;

  @override
  Widget build(BuildContext context) {
    if (chord == null) return const SizedBox.shrink();
    final db = ChordDatabase.instance;
    final entry = db.lookupEntry(chord!.type, chord!.rootNote) ??
        db.lookupEntry(chord!.type, chord!.altRootNote ?? '');
    if (entry == null) return _ChordLabel(chord: chord);

    final notes = isTreble ? entry.trebleClefNotes : entry.bassClefNotes;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: SizedBox(
        width: double.infinity,
        height: 170,
        child: StaffNotationWidget(notes: notes, isTreble: isTreble),
      ),
    );
  }
}

class _DiagramContent extends StatelessWidget {
  const _DiagramContent({
    super.key,
    required this.chord,
    required this.instrument,
  });

  final Chord? chord;
  final String instrument;

  @override
  Widget build(BuildContext context) {
    if (chord == null) return const SizedBox.shrink();
    final db = ChordDatabase.instance;
    var voicing = db.lookupVoicing(instrument, chord!.type, chord!.rootNote);
    voicing ??=
        db.lookupVoicing(instrument, chord!.type, chord!.altRootNote ?? '');
    if (voicing == null) return _ChordLabel(chord: chord);

    final aspectRatio = voicing.numStrings == 4 ? 0.75 : 0.6;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: ChordDiagramWidget(voicing: voicing),
      ),
    );
  }
}
