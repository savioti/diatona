import 'package:flutter/material.dart';

import '../../data/chord_database.dart';

class ChordDiagramWidget extends StatelessWidget {
  const ChordDiagramWidget({super.key, required this.voicing});

  final ChordVoicing voicing;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimaryContainer;
    return CustomPaint(
      painter: _ChordDiagramPainter(voicing: voicing, color: color),
    );
  }
}

class _ChordDiagramPainter extends CustomPainter {
  _ChordDiagramPainter({required this.voicing, required this.color});

  final ChordVoicing voicing;
  final Color color;

  static const int _numFrets = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final n = voicing.numStrings;
    final hasPositionLabel = voicing.baseFret > 1;

    final topMargin = size.height * 0.18;
    final bottomMargin = size.height * 0.04;
    final leftMargin = size.width * (hasPositionLabel ? 0.16 : 0.08);
    final rightMargin = size.width * 0.04;

    final chartWidth = size.width - leftMargin - rightMargin;
    final chartHeight = size.height - topMargin - bottomMargin;
    final stringSpacing = n > 1 ? chartWidth / (n - 1) : chartWidth;
    final fretSpacing = chartHeight / _numFrets;

    final chartLeft = leftMargin;
    final chartTop = topMargin;
    final chartRight = chartLeft + chartWidth;
    final chartBottom = chartTop + chartHeight;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // Bridge (thick bar at nut) or position number
    if (!hasPositionLabel) {
      canvas.drawRect(
        Rect.fromLTRB(chartLeft - 1, chartTop - 5, chartRight + 1, chartTop + 2),
        Paint()..color = color..style = PaintingStyle.fill,
      );
    } else {
      final tp = TextPainter(
        text: TextSpan(
          text: '${voicing.baseFret}',
          style: TextStyle(
            color: color,
            fontSize: fretSpacing * 0.55,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(
          chartLeft - tp.width - size.width * 0.04,
          chartTop + fretSpacing * 0.5 - tp.height / 2,
        ),
      );
    }

    // Strings (vertical lines)
    for (int i = 0; i < n; i++) {
      final x = chartLeft + i * stringSpacing;
      canvas.drawLine(Offset(x, chartTop), Offset(x, chartBottom), linePaint);
    }

    // Frets (horizontal lines)
    for (int f = 0; f <= _numFrets; f++) {
      final y = chartTop + f * fretSpacing;
      canvas.drawLine(Offset(chartLeft, y), Offset(chartRight, y), linePaint);
    }

    // Detect barres: same finger + same relative fret on multiple strings
    final barres = <_Barre>[];
    final groups = <String, List<int>>{};
    for (int i = 0; i < voicing.frets.length; i++) {
      final fret = voicing.frets[i];
      final finger = voicing.fingers[i];
      if (fret == 'x' || fret == 0 || finger == null) continue;
      final relFret = fret as int;
      groups.putIfAbsent('$finger:$relFret', () => []).add(i);
    }
    for (final entry in groups.entries) {
      final indices = entry.value..sort();
      if (indices.length < 2) continue;
      final parts = entry.key.split(':');
      barres.add(_Barre(
        fromStringIndex: indices.first,
        toStringIndex: indices.last,
        relFret: int.parse(parts[1]),
      ));
    }

    final dotRadius = (stringSpacing * 0.32).clamp(4.0, 14.0);

    // Barres (draw behind individual dots)
    for (final b in barres) {
      final xFrom = chartLeft + b.fromStringIndex * stringSpacing;
      final xTo = chartLeft + b.toStringIndex * stringSpacing;
      final y = chartTop + (b.relFret - 1) * fretSpacing + fretSpacing * 0.5;
      final rr = RRect.fromRectAndRadius(
        Rect.fromLTRB(
          xFrom - dotRadius * 0.5,
          y - dotRadius,
          xTo + dotRadius * 0.5,
          y + dotRadius,
        ),
        Radius.circular(dotRadius),
      );
      canvas.drawRRect(rr, Paint()..color = color..style = PaintingStyle.fill);
    }

    // Open/muted markers and fretted dots
    for (int i = 0; i < n; i++) {
      final fret = voicing.frets[i];
      final x = chartLeft + i * stringSpacing;

      if (fret == 'x') {
        _drawX(canvas, x, chartTop - topMargin * 0.5, dotRadius * 0.65, color);
      } else if (fret == 0) {
        canvas.drawCircle(
          Offset(x, chartTop - topMargin * 0.5),
          dotRadius * 0.65,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4,
        );
      } else {
        final relFret = fret as int;
        final y = chartTop + (relFret - 1) * fretSpacing + fretSpacing * 0.5;
        // Skip if a barre covers this string+fret
        final covered = barres.any((b) =>
            b.relFret == relFret &&
            i >= b.fromStringIndex &&
            i <= b.toStringIndex);
        if (!covered) {
          canvas.drawCircle(
            Offset(x, y),
            dotRadius,
            Paint()..color = color..style = PaintingStyle.fill,
          );
        }
      }
    }
  }

  void _drawX(Canvas canvas, double cx, double cy, double r, Color c) {
    final p = Paint()
      ..color = c
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx - r, cy - r), Offset(cx + r, cy + r), p);
    canvas.drawLine(Offset(cx + r, cy - r), Offset(cx - r, cy + r), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

class _Barre {
  const _Barre({
    required this.fromStringIndex,
    required this.toStringIndex,
    required this.relFret,
  });

  final int fromStringIndex;
  final int toStringIndex;
  final int relFret;
}
