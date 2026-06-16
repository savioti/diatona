import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';

// ── Circle of Fifths data ────────────────────────────────────────────────────
const _major        = ['C', 'G', 'D', 'A', 'E', 'B', 'F♯\nG♭', 'D♭', 'A♭', 'E♭', 'B♭', 'F'];
const _minor        = ['Am', 'Em', 'Bm', 'F♯m', 'C♯m', 'G♯m', 'E♭m', 'B♭m', 'Fm', 'Cm', 'Gm', 'Dm'];
const _accidentals  = ['0', '1♯', '2♯', '3♯', '4♯', '5♯', '6♯\n6♭', '5♭', '4♭', '3♭', '2♭', '1♭'];
const _majorDisplay = ['C', 'G', 'D', 'A', 'E', 'B', 'F♯/G♭', 'D♭', 'A♭', 'E♭', 'B♭', 'F'];
// Order of sharps: F♯ C♯ G♯ D♯ A♯ E♯ — order of flats: B♭ E♭ A♭ D♭ G♭ C♭ F♭
const _keySignatures = <List<String>>[
  [],                                              // C  — 0♯/♭
  ['F♯'],                                          // G  — 1♯
  ['F♯', 'C♯'],                                   // D  — 2♯
  ['F♯', 'C♯', 'G♯'],                            // A  — 3♯
  ['F♯', 'C♯', 'G♯', 'D♯'],                     // E  — 4♯
  ['F♯', 'C♯', 'G♯', 'D♯', 'A♯'],              // B  — 5♯
  ['F♯', 'C♯', 'G♯', 'D♯', 'A♯', 'E♯'],        // F♯ — 6♯
  ['B♭', 'E♭', 'A♭', 'D♭', 'G♭'],              // D♭ — 5♭
  ['B♭', 'E♭', 'A♭', 'D♭'],                     // A♭ — 4♭
  ['B♭', 'E♭', 'A♭'],                            // E♭ — 3♭
  ['B♭', 'E♭'],                                   // B♭ — 2♭
  ['B♭'],                                          // F  — 1♭
];
// Circle position → semitone root (C G D A E B F♯/G♭ D♭ A♭ E♭ B♭ F)
const _rootSemitones  = [0, 7, 2, 9, 4, 11, 6, 1, 8, 3, 10, 5];
const _useSharps      = [true, true, true, true, true, true, true, false, false, false, false, false];
const _sharpNotes     = ['C', 'C♯', 'D', 'D♯', 'E', 'F', 'F♯', 'G', 'G♯', 'A', 'A♯', 'B'];
const _flatNotes      = ['C', 'D♭', 'D', 'E♭', 'E', 'F', 'G♭', 'G', 'A♭', 'A', 'B♭', 'B'];
const _scaleIntervals = [0, 2, 4, 5, 7, 9, 11];
const _chordSuffixes  = ['', 'm', 'm', '', '', 'm', '°'];

class CircleOfFifthsWidget extends StatefulWidget {
  const CircleOfFifthsWidget({super.key, this.showFourthsDirection = false});

  final bool showFourthsDirection;

  @override
  State<CircleOfFifthsWidget> createState() => _CircleOfFifthsWidgetState();
}

class _CircleOfFifthsWidgetState extends State<CircleOfFifthsWidget>
    with SingleTickerProviderStateMixin {
  int? _selected;
  late final AnimationController _pulse;
  late final Animation<double> _pulseAnim;

  List<String> _diatonicChords(int circleIndex) {
    final root = _rootSemitones[circleIndex];
    final notes = _useSharps[circleIndex] ? _sharpNotes : _flatNotes;
    return List.generate(7, (i) {
      final note = notes[(root + _scaleIntervals[i]) % 12];
      return '$note${_chordSuffixes[i]}';
    });
  }

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _pulseAnim = CurvedAnimation(parent: _pulse, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _handleTap(Offset localPos, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final r = size.shortestSide * 0.5 * 0.92;
    final offset = localPos - center;
    final dist = offset.distance;
    if (dist < r * 0.20 || dist > r * 0.98) return;

    var angle = atan2(offset.dx, -offset.dy);
    if (angle < 0) angle += 2 * pi;

    final index = (angle / (2 * pi / 12)).floor() % 12;
    setState(() => _selected = _selected == index ? null : index);
    if (_selected != null) _pulse.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            widget.showFourthsDirection
                ? AppLocalizations.of(context).refAscendingFourths
                : AppLocalizations.of(context).refAscendingFifths,
            style: theme.textTheme.bodySmall?.copyWith(color: cs.primary),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final side = constraints.maxWidth.clamp(
                0.0,
                constraints.maxHeight,
              );
              return Center(
                child: GestureDetector(
                  onTapUp: (d) => _handleTap(d.localPosition, Size(side, side)),
                  child: SizedBox(
                    width: side,
                    height: side,
                    child: AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (_, _) => CustomPaint(
                        painter: _CirclePainter(
                          major: _major,
                          minor: _minor,
                          accidentals: _accidentals,
                          selectedIndex: _selected,
                          cs: cs,
                          pulse: _pulseAnim.value,
                          showFourths: widget.showFourthsDirection,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _selected == null
              ? Padding(
                  key: const ValueKey('hint'),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    AppLocalizations.of(context).refTapKeyToExplore,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : _InfoPanel(
                  key: ValueKey(_selected),
                  majorKey: _majorDisplay[_selected!],
                  minorKey: _minor[_selected!],
                  keySignature: _keySignatures[_selected!],
                  chords: _diatonicChords(_selected!),
                  cs: cs,
                ),
        ),
      ],
    );
  }
}

// ── Custom painter ───────────────────────────────────────────────────────────

class _CirclePainter extends CustomPainter {
  const _CirclePainter({
    required this.major,
    required this.minor,
    required this.accidentals,
    required this.selectedIndex,
    required this.cs,
    required this.pulse,
    required this.showFourths,
  });

  final List<String> major;
  final List<String> minor;
  final List<String> accidentals;
  final int? selectedIndex;
  final ColorScheme cs;
  final double pulse;
  final bool showFourths;

  static const _sweepCount = 12;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final R = size.shortestSide / 2 * 0.92;

    final r0 = R * 0.20; // center
    final r1 = R * 0.42; // inner accidentals ring inner
    final r2 = R * 0.62; // minor ring inner
    final r3 = R * 0.82; // major ring inner
    final r4 = R * 0.97; // outer

    const sweep = 2 * pi / _sweepCount;
    const startAngle = -pi / 2;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = cs.onSurface.withAlpha(40)
      ..strokeWidth = 1.2;

    for (int i = 0; i < _sweepCount; i++) {
      final a = startAngle + i * sweep;
      final selected = selectedIndex == i;

      // Major key ring (outer)
      _fillRing(
        canvas,
        c,
        r3,
        r4,
        a,
        sweep,
        selected ? cs.primary : cs.primaryContainer,
      );
      _strokeRing(canvas, c, r3, r4, a, sweep, borderPaint);

      // Minor key ring (middle)
      _fillRing(
        canvas,
        c,
        r2,
        r3,
        a,
        sweep,
        selected ? cs.secondary : cs.surface,
      );
      _strokeRing(canvas, c, r2, r3, a, sweep, borderPaint);

      // Accidentals ring (inner)
      _fillRing(
        canvas,
        c,
        r1,
        r2,
        a,
        sweep,
        selected ? cs.tertiary.withAlpha(180) : cs.surface.withAlpha(80),
      );
      _strokeRing(canvas, c, r1, r2, a, sweep, borderPaint);

      final mid = a + sweep / 2;

      _drawLabel(
        canvas,
        major[i],
        c,
        (r3 + r4) / 2,
        mid,
        selected ? cs.onPrimary : cs.onPrimaryContainer,
        11,
        true,
      );

      _drawLabel(
        canvas,
        minor[i],
        c,
        (r2 + r3) / 2,
        mid,
        selected ? cs.onSecondary : cs.onSurface,
        8.5,
        false,
      );

      _drawLabel(
        canvas,
        accidentals[i],
        c,
        (r1 + r2) / 2,
        mid,
        selected ? cs.onTertiary : cs.onSurface.withAlpha(160),
        8,
        false,
      );
    }

    // Center circle
    canvas.drawCircle(c, r1, Paint()..color = cs.primaryContainer);
    canvas.drawCircle(c, r0, Paint()..color = cs.primary.withAlpha(50));

    // Direction arrow in center
    _drawDirectionArrow(canvas, c, r0 * 0.75);
  }

  void _drawDirectionArrow(Canvas canvas, Offset c, double r) {
    final paint = Paint()
      ..color = cs.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Curved arc arrow: clockwise for fifths, counter-clockwise for fourths
    const startAngle = -pi * 0.75;
    const sweepAngle = pi * 1.5;
    final arcRect = Rect.fromCircle(center: c, radius: r);
    final path = Path()
      ..addArc(arcRect, startAngle, showFourths ? -sweepAngle : sweepAngle);
    canvas.drawPath(path, paint);

    // Arrowhead
    final arrowEnd = showFourths ? startAngle : startAngle + sweepAngle;
    final tipX = c.dx + r * cos(arrowEnd);
    final tipY = c.dy + r * sin(arrowEnd);
    final tangentAngle = arrowEnd + (showFourths ? pi / 2 : -pi / 2);
    const arrowSize = 5.0;
    final a1x = tipX + arrowSize * cos(tangentAngle + 0.5);
    final a1y = tipY + arrowSize * sin(tangentAngle + 0.5);
    final a2x = tipX + arrowSize * cos(tangentAngle - 0.5);
    final a2y = tipY + arrowSize * sin(tangentAngle - 0.5);
    canvas.drawLine(Offset(tipX, tipY), Offset(a1x, a1y), paint);
    canvas.drawLine(Offset(tipX, tipY), Offset(a2x, a2y), paint);
  }

  void _fillRing(
    Canvas canvas,
    Offset c,
    double r1,
    double r2,
    double a,
    double sweep,
    Color color,
  ) {
    canvas.drawPath(
      _annularSector(c, r1, r2, a, sweep),
      Paint()
        ..style = PaintingStyle.fill
        ..color = color,
    );
  }

  void _strokeRing(
    Canvas canvas,
    Offset c,
    double r1,
    double r2,
    double a,
    double sweep,
    Paint p,
  ) {
    canvas.drawPath(_annularSector(c, r1, r2, a, sweep), p);
  }

  Path _annularSector(Offset c, double r1, double r2, double a, double sweep) {
    return Path()
      ..moveTo(c.dx + r1 * cos(a), c.dy + r1 * sin(a))
      ..lineTo(c.dx + r2 * cos(a), c.dy + r2 * sin(a))
      ..arcTo(Rect.fromCircle(center: c, radius: r2), a, sweep, false)
      ..lineTo(c.dx + r1 * cos(a + sweep), c.dy + r1 * sin(a + sweep))
      ..arcTo(Rect.fromCircle(center: c, radius: r1), a + sweep, -sweep, false)
      ..close();
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset c,
    double radius,
    double angle,
    Color color,
    double fontSize,
    bool bold,
  ) {
    final x = c.dx + radius * cos(angle);
    final y = c.dy + radius * sin(angle);

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          height: 1.1,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 48);

    tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
  }

  @override
  bool shouldRepaint(_CirclePainter old) =>
      old.selectedIndex != selectedIndex ||
      old.pulse != pulse ||
      old.showFourths != showFourths;
}

// ── Info panel ───────────────────────────────────────────────────────────────

enum _ChordKind { tonic, minor, subdominant, dominant, dim }

const _numerals = ['I', 'ii', 'iii', 'IV', 'V', 'vi', 'vii°'];
const _kinds = [
  _ChordKind.tonic,
  _ChordKind.minor,
  _ChordKind.minor,
  _ChordKind.subdominant,
  _ChordKind.dominant,
  _ChordKind.minor,
  _ChordKind.dim,
];

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    super.key,
    required this.majorKey,
    required this.minorKey,
    required this.keySignature,
    required this.chords,
    required this.cs,
  });

  final String majorKey;
  final String minorKey;
  final List<String> keySignature;
  final List<String> chords;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sigText = keySignature.isEmpty
        ? l10n.refNoAccidentals
        : keySignature.join('  ');
    final fnLabels = <String?>[
      l10n.refFnTonic,
      null,
      null,
      l10n.refFnSubdominant,
      l10n.refFnDominant,
      null,
      null,
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: key name (left) + key signature (right) ──────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$majorKey ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: cs.onPrimaryContainer,
                          ),
                        ),
                        TextSpan(
                          text: 'Major',
                          style: TextStyle(
                            fontSize: 13,
                            color: cs.onPrimaryContainer.withAlpha(130),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'rel. $minorKey',
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _SectionLabel(label: l10n.refKeySignature, cs: cs),
                  const SizedBox(height: 3),
                  Text(
                    sigText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.tertiary,
                      letterSpacing: 0.4,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // ── Diatonic chord cards ──────────────────────────────────────
          _SectionLabel(label: l10n.refDiatonicChords, cs: cs),
          const SizedBox(height: 6),
          Row(
            children: List.generate(
              7,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 6 ? 3 : 0),
                  child: _ChordCard(
                    numeral: _numerals[i],
                    chord: chords[i],
                    fnLabel: fnLabels[i],
                    kind: _kinds[i],
                    cs: cs,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChordCard extends StatelessWidget {
  const _ChordCard({
    required this.numeral,
    required this.chord,
    required this.fnLabel,
    required this.kind,
    required this.cs,
  });

  final String numeral;
  final String chord;
  final String? fnLabel;
  final _ChordKind kind;
  final ColorScheme cs;

  Color get _bg => switch (kind) {
    _ChordKind.tonic => cs.primary,
    _ChordKind.subdominant => cs.primary.withAlpha(55),
    _ChordKind.dominant => cs.secondary,
    _ChordKind.dim => cs.tertiary.withAlpha(45),
    _ChordKind.minor => cs.onPrimaryContainer.withAlpha(18),
  };

  Color get _border => switch (kind) {
    _ChordKind.tonic => cs.primary,
    _ChordKind.subdominant => cs.primary.withAlpha(110),
    _ChordKind.dominant => cs.secondary,
    _ChordKind.dim => cs.tertiary.withAlpha(90),
    _ChordKind.minor => cs.onPrimaryContainer.withAlpha(45),
  };

  Color get _numeralColor => switch (kind) {
    _ChordKind.tonic => cs.onPrimary,
    _ChordKind.dominant => cs.onSecondary,
    _ChordKind.subdominant => cs.primary,
    _ChordKind.dim => cs.tertiary,
    _ChordKind.minor => cs.onPrimaryContainer.withAlpha(160),
  };

  Color get _chordColor => switch (kind) {
    _ChordKind.tonic => cs.onPrimary,
    _ChordKind.dominant => cs.onSecondary,
    _ => cs.onPrimaryContainer,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: _border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            numeral,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: _numeralColor,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              chord,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _chordColor,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 13,
            child: fnLabel != null
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      fnLabel!,
                      style: TextStyle(
                        fontSize: 7,
                        color: _numeralColor,
                        height: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.cs});
  final String label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: cs.onPrimaryContainer.withAlpha(140),
      letterSpacing: 0.8,
    ),
  );
}
