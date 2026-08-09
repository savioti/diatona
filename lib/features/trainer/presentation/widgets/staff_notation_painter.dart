import 'package:flutter/material.dart';

class StaffNotationWidget extends StatelessWidget {
  const StaffNotationWidget({
    super.key,
    required this.notes,
    required this.isTreble,
  });

  final List<String> notes;
  final bool isTreble;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimaryContainer;
    return CustomPaint(
      painter: _StaffNotationPainter(
        notes: notes,
        isTreble: isTreble,
        color: color,
      ),
    );
  }
}

class _StaffNotationPainter extends CustomPainter {
  _StaffNotationPainter({
    required this.notes,
    required this.isTreble,
    required this.color,
  });

  final List<String> notes;
  final bool isTreble;
  final Color color;

  // Diatonic step within octave: C=0, D=1, E=2, F=3, G=4, A=5, B=6
  static const _diatonic = <String, int>{
    'C': 0, 'D': 1, 'E': 2, 'F': 3, 'G': 4, 'A': 5, 'B': 6,
  };

  // Treble clef reference: E4 is on the bottom (first) staff line → step 0.
  // Diatonic absolute value of E4 = 2 + 4*7 = 30.
  static const _trebleRef = 30;

  // Bass clef reference: G2 is on the bottom (first) staff line → step 0.
  // Diatonic absolute value of G2 = 4 + 2*7 = 18.
  static const _bassRef = 18;

  /// Maps a note string like "C4", "Eb4", "G#4" to a staff step.
  /// Step 0 = bottom staff line, step 2 = second line, step 8 = top line.
  /// Accidentals are ignored for vertical placement; they are drawn separately.
  int _noteStep(String noteStr) {
    final m = RegExp(r'^([A-G])([#b]?)(-?\d+)$').firstMatch(noteStr);
    if (m == null) return 0;
    final octave = int.parse(m.group(3)!);
    final diatonic = (_diatonic[m.group(1)!] ?? 0) + octave * 7;
    return diatonic - (isTreble ? _trebleRef : _bassRef);
  }

  String _accidental(String noteStr) {
    final m = RegExp(r'^[A-G]([#b]?)').firstMatch(noteStr);
    return m?.group(1) ?? '';
  }

  @override
  void paint(Canvas canvas, Size size) {
    const numLines = 5;

    final leftPad = size.width * 0.04;
    final rightPad = size.width * 0.04;
    final clefAreaWidth = size.width * 0.22;

    // Staff occupies the vertical center of the canvas
    final staffTop = size.height * 0.18;
    final staffBottom = size.height * 0.82;
    final staffHeight = staffBottom - staffTop;
    final lineSpacing = staffHeight / (numLines - 1);
    final halfStep = lineSpacing / 2;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // Staff lines at steps 0, 2, 4, 6, 8 (bottom to top)
    for (int i = 0; i < numLines; i++) {
      final y = staffBottom - i * lineSpacing;
      canvas.drawLine(
        Offset(leftPad + clefAreaWidth * 0.1, y),
        Offset(size.width - rightPad, y),
        linePaint,
      );
    }

    // Clef symbol
    final clefSymbol = isTreble ? '\u{1D11E}' : '\u{1D122}';
    // Treble clef is tall; bass clef is about 2.5 staff spaces high.
    final clefFontSize = isTreble ? lineSpacing * 4.2 : lineSpacing * 2.6;
    final clefPainter = TextPainter(
      text: TextSpan(
        text: clefSymbol,
        style: TextStyle(
          color: color,
          fontSize: clefFontSize,
          fontFamily: 'serif',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: clefAreaWidth);

    // Position: treble clef bottom tail sits at/near E4 (step 0 = staffBottom).
    // Bass clef sits so its two dots are between lines 3 and 4 (steps 6 and 8).
    final clefY = isTreble
        ? staffBottom - lineSpacing * 3.8 - clefPainter.height * 0.05
        : staffBottom - lineSpacing * 2.2 - clefPainter.height * 0.5;
    clefPainter.paint(canvas, Offset(leftPad, clefY));

    // Note area: horizontally centered in the remaining space
    final noteAreaLeft = leftPad + clefAreaWidth;
    final noteX = noteAreaLeft + (size.width - rightPad - noteAreaLeft) / 2;
    final noteRx = lineSpacing * 0.56;
    final noteRy = lineSpacing * 0.38;
    final ledgerHalfWidth = noteRx * 1.5;

    final steps = notes.map(_noteStep).toList();
    final accidentals = notes.map(_accidental).toList();

    // Ledger lines outside the 5-line staff
    final ledgerSteps = <int>{};
    for (final s in steps) {
      if (s < 0) {
        for (int k = -2; k >= s; k -= 2) {
          ledgerSteps.add(k);
        }
      } else if (s > 8) {
        for (int k = 10; k <= s; k += 2) {
          ledgerSteps.add(k);
        }
      }
    }
    for (final ls in ledgerSteps) {
      final y = staffBottom - ls * halfStep;
      canvas.drawLine(
        Offset(noteX - ledgerHalfWidth, y),
        Offset(noteX + ledgerHalfWidth, y),
        linePaint,
      );
    }

    // Noteheads and accidentals
    final notePaint = Paint()..color = color..style = PaintingStyle.fill;

    for (int i = 0; i < steps.length; i++) {
      final y = staffBottom - steps[i] * halfStep;

      // Filled oval notehead, slightly tilted for classical appearance
      canvas.save();
      canvas.translate(noteX, y);
      canvas.rotate(-0.15);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: noteRx * 2,
          height: noteRy * 2,
        ),
        notePaint,
      );
      canvas.restore();

      // Accidental (♯ or ♭) to the left of the notehead
      final acc = accidentals[i];
      if (acc.isNotEmpty) {
        final accSymbol = acc == '#' ? '♯' : '♭';
        final accPainter = TextPainter(
          text: TextSpan(
            text: accSymbol,
            style: TextStyle(color: color, fontSize: lineSpacing * 1.1),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        accPainter.paint(
          canvas,
          Offset(
            noteX - noteRx - accPainter.width - 2,
            y - accPainter.height * 0.62,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}
