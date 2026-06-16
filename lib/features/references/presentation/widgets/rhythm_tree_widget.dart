import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';

// ── Rhythm tree data ─────────────────────────────────────────────────────────
const _levels = [
  _Level(symbol: '𝅝',  name: 'Whole Note',     count: 1,  beats: '4 beats',      syllable: '1 . . . 2 . . . 3 . . . 4',         color: Color(0xFF5158BB)),
  _Level(symbol: '𝅗𝅥', name: 'Half Note',      count: 2,  beats: '2 beats each', syllable: '1 . . 2 . . 3 . . 4',               color: Color(0xFF7B61FF)),
  _Level(symbol: '♩',  name: 'Quarter Note',   count: 4,  beats: '1 beat each',  syllable: '1   2   3   4',                      color: Color(0xFFEB4B98)),
  _Level(symbol: '♪',  name: 'Eighth Note',    count: 8,  beats: '½ beat each',  syllable: '1 & 2 & 3 & 4 &',                   color: Color(0xFFF26DF9)),
  _Level(symbol: '𝅘𝅥𝅯', name: 'Sixteenth Note', count: 16, beats: '¼ beat each',  syllable: '1 e & a  2 e & a  3 e & a  4 e & a', color: Color(0xFFFC9E4F)),
];

class RhythmTreeWidget extends StatefulWidget {
  const RhythmTreeWidget({super.key});

  @override
  State<RhythmTreeWidget> createState() => _RhythmTreeWidgetState();
}

class _RhythmTreeWidgetState extends State<RhythmTreeWidget> {
  final _expanded = <int>{};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context).refTapLevelExpand,
          style: theme.textTheme.bodySmall
              ?.copyWith(fontStyle: FontStyle.italic, color: cs.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(_levels.length, (i) {
                final level = _levels[i];
                final isOpen = _expanded.contains(i);
                return _LevelRow(
                  level: level,
                  depth: i,
                  isOpen: isOpen,
                  onTap: () => setState(() {
                    if (isOpen) {
                      _expanded.remove(i);
                    } else {
                      _expanded.add(i);
                    }
                  }),
                  cs: cs,
                  theme: theme,
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class _LevelRow extends StatelessWidget {
  const _LevelRow({
    required this.level,
    required this.depth,
    required this.isOpen,
    required this.onTap,
    required this.cs,
    required this.theme,
  });

  final _Level level;
  final int depth;
  final bool isOpen;
  final VoidCallback onTap;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: depth * 12.0, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row
          GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isOpen
                    ? level.color.withAlpha(220)
                    : level.color.withAlpha(60),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: level.color.withAlpha(180), width: 1),
              ),
              child: Row(
                children: [
                  Text(
                    level.symbol,
                    style: TextStyle(
                      fontSize: 20,
                      color: isOpen ? Colors.white : level.color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${level.count}× ${level.name}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isOpen ? Colors.white : cs.onSurface,
                          ),
                        ),
                        Text(
                          level.beats,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isOpen
                                ? Colors.white.withAlpha(200)
                                : cs.onSurface.withAlpha(140),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isOpen
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: isOpen ? Colors.white : level.color,
                  ),
                ],
              ),
            ),
          ),
          // Expanded content: note grid + syllable
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: isOpen
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Note boxes
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              level.count,
                              (_) => Container(
                                width: 32,
                                height: 32,
                                margin: const EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                  color: level.color.withAlpha(40),
                                  border: Border.all(
                                      color: level.color.withAlpha(160)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    level.symbol,
                                    style: TextStyle(
                                        fontSize: 14, color: level.color),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Counting syllables
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: level.color.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            level.syllable,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                              color: level.color,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _Level {
  const _Level({
    required this.symbol,
    required this.name,
    required this.count,
    required this.beats,
    required this.syllable,
    required this.color,
  });

  final String symbol;
  final String name;
  final int count;
  final String beats;
  final String syllable;
  final Color color;
}
