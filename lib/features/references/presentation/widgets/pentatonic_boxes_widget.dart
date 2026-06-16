import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';

class PentatonicBoxesWidget extends StatefulWidget {
  const PentatonicBoxesWidget({super.key});

  @override
  State<PentatonicBoxesWidget> createState() => _PentatonicBoxesWidgetState();
}

// ── Pentatonic boxes data ────────────────────────────────────────────────────
const _rootNames = ['C', 'C♯', 'D', 'E♭', 'E', 'F', 'F♯', 'G', 'A♭', 'A', 'B♭', 'B'];
const _boxColors = [
  Color(0xFFEB4B98),
  Color(0xFF5158BB),
  Color(0xFF2ECC71),
  Color(0xFFF39C12),
  Color(0xFF9B59B6),
];
const _boxLabels = ['Box 1', 'Box 2', 'Box 3', 'Box 4', 'Box 5'];
// Each box: list of (stringIdx 0=lowE, fretOffset, isRoot)
// fretOffset is relative to the box's startFret
const _boxes = [
    _Box(
      startFret: 5, // for Am: A root at string 5(A) fret 0 and string 6(E) fret 5
      dots: [
        (0, 0, true), (0, 3, false), // s6 (low E): A(R), C
        (1, 0, false), (1, 2, false), // s5 (A):   D, E
        (2, 0, false), (2, 2, true),  // s4 (D):   G, A(R)
        (3, 0, false), (3, 2, false), // s3 (G):   C, D
        (4, 0, false), (4, 3, false), // s2 (B):   E, G
        (5, 0, true),  (5, 3, false), // s1 (e):   A(R), C
      ],
    ),
    _Box(
      startFret: 7,
      dots: [
        (0, 1, false), (0, 3, false),
        (1, 0, false), (1, 3, false),
        (2, 0, true),  (2, 3, false),
        (3, 0, false), (3, 2, false),
        (4, 1, false), (4, 3, true),
        (5, 1, false), (5, 3, false),
      ],
    ),
    _Box(
      startFret: 9,
      dots: [
        (0, 1, false), (0, 3, false),
        (1, 1, false), (1, 3, true),
        (2, 1, false), (2, 3, false),
        (3, 0, false), (3, 3, false),
        (4, 1, true),               // single note on B string
        (5, 1, false), (5, 3, false),
      ],
    ),
    _Box(
      startFret: 12,
      dots: [
        (0, 0, false), (0, 3, false),
        (1, 0, true),  (1, 3, false),
        (2, 0, false), (2, 2, false),
        (3, 0, false), (3, 2, true),
        (4, 1, false), (4, 3, false),
        (5, 0, false), (5, 3, false),
      ],
    ),
    _Box(
      startFret: 2,
      dots: [
        (0, 1, false), (0, 3, true),
        (1, 1, false), (1, 3, false),
        (2, 0, false), (2, 3, false),
        (3, 0, true),  (3, 3, false),
        (4, 1, false), (4, 3, false),
        (5, 1, false), (5, 3, true),
      ],
    ),
];

class _PentatonicBoxesWidgetState extends State<PentatonicBoxesWidget> {
  int _rootIndex = 9; // default: A (index 9 in chromatic)
  final Set<int> _activeBoxes = {0};

  // Semitone root offsets: A minor pentatonic has root A=9.
  // Each box's actual startFret shifts by (selectedRoot - 9) semitones.
  int _actualStartFret(int boxIdx) {
    final shift = (_rootIndex - 9 + 12) % 12;
    return (_boxes[boxIdx].startFret + shift - 1) % 12 + 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        // Root note picker
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _rootNames.length,
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (_, i) => ChoiceChip(
              label: Text(_rootNames[i]),
              selected: _rootIndex == i,
              onSelected: (_) => setState(() => _rootIndex = i),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Box toggles
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final active = _activeBoxes.contains(i);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                onTap: () => setState(() {
                  if (active && _activeBoxes.length > 1) {
                    _activeBoxes.remove(i);
                  } else {
                    _activeBoxes.add(i);
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: active
                        ? _boxColors[i].withAlpha(220)
                        : _boxColors[i].withAlpha(40),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: _boxColors[i].withAlpha(180)),
                  ),
                  child: Text(
                    _boxLabels[i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: active ? Colors.white : _boxColors[i],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        // Fretboard
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _FretboardPainter(
                activeBoxes: _activeBoxes,
                boxes: _boxes,
                boxColors: _boxColors,
                rootIndex: _rootIndex,
                actualStartFrets: List.generate(5, _actualStartFret),
                cs: cs,
              ),
            );
          }),
        ),
        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            AppLocalizations.of(context).refPentatonicLegend,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: cs.onSurface.withAlpha(130)),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _FretboardPainter extends CustomPainter {
  const _FretboardPainter({
    required this.activeBoxes,
    required this.boxes,
    required this.boxColors,
    required this.rootIndex,
    required this.actualStartFrets,
    required this.cs,
  });

  final Set<int> activeBoxes;
  final List<_Box> boxes;
  final List<Color> boxColors;
  final int rootIndex;
  final List<int> actualStartFrets;
  final ColorScheme cs;

  static const _strings = 6;
  static const _fretCount = 16; // frets 0..15 displayed

  @override
  void paint(Canvas canvas, Size size) {
    final fretW = size.width / (_fretCount + 1);
    final stringH = size.height / (_strings + 1);
    final dotR = min(fretW, stringH) * 0.28;

    final linePaint = Paint()
      ..color = cs.onSurface.withAlpha(60)
      ..strokeWidth = 1;
    final nutPaint = Paint()
      ..color = cs.onSurface.withAlpha(180)
      ..strokeWidth = 3;

    // String lines (horizontal)
    for (int s = 0; s < _strings; s++) {
      final y = (s + 1) * stringH;
      canvas.drawLine(Offset(fretW, y), Offset(size.width, y), linePaint);
    }

    // Fret lines (vertical) + labels
    for (int f = 0; f <= _fretCount; f++) {
      final x = (f + 1) * fretW;
      final paint = f == 0 ? nutPaint : linePaint;
      canvas.drawLine(Offset(x, stringH), Offset(x, _strings * stringH), paint);

      // Fret number label
      if (f > 0 && f % 2 == 1) {
        _drawText(canvas, '$f', Offset(x - fretW / 2, stringH * 0.4),
            TextStyle(color: cs.onSurface.withAlpha(100), fontSize: 9));
      }
    }

    // String labels (low E left to high e right)
    const stringNames = ['E', 'A', 'D', 'G', 'B', 'e'];
    for (int s = 0; s < _strings; s++) {
      _drawText(
          canvas,
          stringNames[s],
          Offset(fretW * 0.5, (s + 1) * stringH),
          TextStyle(
              color: cs.onSurface.withAlpha(130),
              fontSize: 9,
              fontWeight: FontWeight.bold));
    }

    // Draw dots for active boxes
    for (int bi = 0; bi < boxes.length; bi++) {
      if (!activeBoxes.contains(bi)) continue;
      final box = boxes[bi];
      final color = boxColors[bi];
      final startFret = actualStartFrets[bi];

      for (final (strIdx, fretOffset, isRoot) in box.dots) {
        final fret = (startFret + fretOffset - 1) % _fretCount + 1;
        // string 0 = low E = top row, string 5 = high e = bottom row
        final x = fret * fretW - fretW / 2;
        final y = (strIdx + 1) * stringH;

        if (isRoot) {
          // Root: filled circle with ring
          canvas.drawCircle(Offset(x, y), dotR, Paint()..color = color);
          canvas.drawCircle(
              Offset(x, y),
              dotR,
              Paint()
                ..color = Colors.white.withAlpha(200)
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.5);
        } else {
          canvas.drawCircle(Offset(x, y), dotR * 0.82,
              Paint()..color = color.withAlpha(180));
        }
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset center, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_FretboardPainter old) =>
      old.activeBoxes != activeBoxes ||
      old.rootIndex != rootIndex;
}

class _Box {
  const _Box({required this.startFret, required this.dots});
  final int startFret;
  final List<(int, int, bool)> dots;
}
