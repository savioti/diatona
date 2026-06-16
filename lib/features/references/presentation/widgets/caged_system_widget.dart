import 'dart:math';

import 'package:flutter/material.dart';

class CagedSystemWidget extends StatefulWidget {
  const CagedSystemWidget({super.key});

  @override
  State<CagedSystemWidget> createState() => _CagedSystemWidgetState();
}

// ── CAGED system data ────────────────────────────────────────────────────────
// Each shape: list of (stringIndex 0=low-E…5=high-e, relativeFret, isRoot)
// relativeFret 0 = open / shape start position
const _cC = [
  (5, 3, true),  // A string fret 3 = root
  (4, 2, false), // D string fret 2
  (3, 0, false), // G open
  (2, 1, false), // B fret 1
  (1, 0, false), // e open
];
const _cA = [
  (5, 0, true),  // A open = root
  (4, 2, false),
  (3, 2, false),
  (2, 2, false),
  (1, 0, false),
];
const _cG = [
  (0, 3, true),  // low E fret 3 = root
  (5, 0, false),
  (5, 2, false),
  (4, 0, false),
  (3, 0, false),
  (2, 0, false),
  (1, 3, true),  // high e fret 3 = root octave
  (0, 2, false),
];
const _cE = [
  (0, 0, true),  // low E open = root
  (5, 2, false),
  (4, 2, false),
  (3, 1, false),
  (2, 0, false),
  (1, 0, true),  // high e open = root
];
const _cD = [
  (4, 0, true),  // D open = root
  (3, 2, false),
  (2, 3, false),
  (1, 2, false),
];
// Corrected E shape (open E chord: 0 2 2 1 0 0)
const _cEFixed = [
  (0, 0, true),
  (5, 2, false),
  (4, 2, false),
  (3, 1, false),
  (2, 0, false),
  (1, 0, true),
];
const _shapes      = [_cC, _cA, _cG, _cE, _cD];
const _letters     = ['C', 'A', 'G', 'E', 'D'];
const _rootStrings = [
  'Root on A string (5th)',
  'Root on A string (5th)',
  'Root on both E strings (6th & 1st)',
  'Root on both E strings (6th & 1st)',
  'Root on D string (4th)',
];
const _descriptions = [
  'Open C chord shape. Barre it up the neck and the root stays on the A string.',
  'Open A chord shape. Barre with the index finger; ring or pinky covers D–G–B.',
  'Open G chord shape. Roots on both E strings — pinky and ring reach fret 3.',
  'Open E chord shape. Easiest barre; roots on the thinnest and thickest strings.',
  'Open D chord shape. Root on the D string; thickest two strings are muted.',
];

class _CagedSystemWidgetState extends State<CagedSystemWidget>
    with SingleTickerProviderStateMixin {
  int _shapeIndex = 0;
  late final AnimationController _anim;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _select(int i) {
    if (i == _shapeIndex) return;
    _anim.forward(from: 0);
    setState(() => _shapeIndex = i);
  }

  List<(int, int, bool)> get _currentDots {
    if (_shapeIndex == 3) return _cEFixed;
    return _shapes[_shapeIndex];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        // Shape selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final active = _shapeIndex == i;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => _select(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: active ? cs.primary : cs.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      _letters[i],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: active ? cs.onPrimary : cs.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        // Chord diagram
        Expanded(
          child: FadeTransition(
            opacity: _fade,
            child: LayoutBuilder(builder: (context, c) {
              final size = min(c.maxWidth, c.maxHeight);
              return Center(
                child: SizedBox(
                  width: size * 0.7,
                  height: size * 0.7,
                  child: CustomPaint(
                    painter: _ChordDiagramPainter(
                      dots: _currentDots,
                      cs: cs,
                      showMutedLowE: _shapeIndex != 2 && _shapeIndex != 3,
                      showMutedA: _shapeIndex == 4,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        // Description
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Container(
            key: ValueKey(_shapeIndex),
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  _rootStrings[_shapeIndex],
                  style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold, color: cs.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  _descriptions[_shapeIndex],
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChordDiagramPainter extends CustomPainter {
  const _ChordDiagramPainter({
    required this.dots,
    required this.cs,
    required this.showMutedLowE,
    required this.showMutedA,
  });

  final List<(int, int, bool)> dots;
  final ColorScheme cs;
  final bool showMutedLowE;
  final bool showMutedA;

  // 6 strings (0=low E left, 5=high e right), 5 fret rows
  static const _strings = 6;
  static const _fretRows = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final stringSpacing = size.width / (_strings - 1);
    final fretSpacing = size.height / _fretRows;
    final dotR = stringSpacing * 0.3;

    final linePaint = Paint()
      ..color = cs.onSurface.withAlpha(120)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw fret lines
    for (int f = 0; f <= _fretRows; f++) {
      final y = f * fretSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Draw string lines
    for (int s = 0; s < _strings; s++) {
      final x = s * stringSpacing;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    // Nut (thick top line)
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, 0),
      Paint()
        ..color = cs.onSurface.withAlpha(200)
        ..strokeWidth = 4,
    );

    // Draw muted strings
    final muteStyle = TextStyle(
        color: cs.onSurface.withAlpha(160), fontSize: 12, fontWeight: FontWeight.bold);
    if (showMutedLowE) {
      _drawText(canvas, '×', Offset(0, -fretSpacing * 0.6), muteStyle);
    }
    if (showMutedA) {
      _drawText(canvas, '×', Offset(stringSpacing, -fretSpacing * 0.6), muteStyle);
    }

    // Draw dots
    // string index 0 = low E = left column = x=0
    // string index 5 = high e = right column = x=5*stringSpacing
    // fret 0 = open (shown above nut), fret 1..4 = first four frets
    for (final (strIdx, fret, isRoot) in dots) {
      // strIdx: 0=low-E(leftmost), 5=high-e(rightmost)
      // But our diagram: x=0 is low E (leftmost)
      final x = strIdx * stringSpacing;

      if (fret == 0) {
        // Open string — draw circle above nut
        final y = -fretSpacing * 0.5;
        canvas.drawCircle(
          Offset(x, y),
          dotR * 0.75,
          Paint()
            ..color = isRoot ? cs.primary : Colors.transparent
            ..style = PaintingStyle.fill,
        );
        canvas.drawCircle(
          Offset(x, y),
          dotR * 0.75,
          Paint()
            ..color = isRoot ? cs.primary : cs.onSurface.withAlpha(160)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      } else {
        // Fretted — center of fret cell
        final y = (fret - 0.5) * fretSpacing;
        canvas.drawCircle(
          Offset(x, y),
          dotR,
          Paint()
            ..color = isRoot ? cs.primary : cs.onSurface.withAlpha(200)
            ..style = PaintingStyle.fill,
        );
        if (isRoot) {
          _drawText(
            canvas,
            'R',
            Offset(x, y),
            TextStyle(
                color: cs.onPrimary,
                fontSize: dotR * 1.0,
                fontWeight: FontWeight.bold),
          );
        }
      }
    }

    // Fret number labels on the left (for non-open shapes the numbers would matter,
    // but these are open shapes so just label frets 1–4)
    for (int f = 1; f <= 4; f++) {
      _drawText(
        canvas,
        '$f',
        Offset(-stringSpacing * 0.6, (f - 0.5) * fretSpacing),
        TextStyle(color: cs.onSurface.withAlpha(120), fontSize: 9),
      );
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
  bool shouldRepaint(_ChordDiagramPainter old) => old.dots != dots;
}
