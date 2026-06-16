import 'package:flutter/material.dart';

class ChordQualitiesWidget extends StatefulWidget {
  const ChordQualitiesWidget({super.key});

  @override
  State<ChordQualitiesWidget> createState() => _ChordQualitiesWidgetState();
}

// ── Chord qualities data ─────────────────────────────────────────────────────
const _rootNames = ['C', 'C♯', 'D', 'E♭', 'E', 'F', 'F♯', 'G', 'A♭', 'A', 'B♭', 'B'];
const _chromatic = ['C', 'C♯', 'D', 'E♭', 'E', 'F', 'F♯', 'G', 'A♭', 'A', 'B♭', 'B'];
const _qualities = [
    _Quality('Major',               '1  3  5',           [0, 4, 7]),
    _Quality('Minor',               '1  ♭3  5',          [0, 3, 7]),
    _Quality('Augmented',           '1  3  ♯5',          [0, 4, 8]),
    _Quality('Diminished',          '1  ♭3  ♭5',         [0, 3, 6]),
    _Quality('Sus2',                '1  2  5',           [0, 2, 7]),
    _Quality('Sus4',                '1  4  5',           [0, 5, 7]),
    _Quality('Dominant 7th',        '1  3  5  ♭7',       [0, 4, 7, 10]),
    _Quality('Major 7th',           '1  3  5  7',        [0, 4, 7, 11]),
    _Quality('Minor 7th',           '1  ♭3  5  ♭7',      [0, 3, 7, 10]),
    _Quality('Diminished 7th',      '1  ♭3  ♭5  ♭♭7',   [0, 3, 6, 9]),
    _Quality('Half-Dim 7th (ø)',    '1  ♭3  ♭5  ♭7',     [0, 3, 6, 10]),
    _Quality('Minor-Major 7th',     '1  ♭3  5  7',       [0, 3, 7, 11]),
    _Quality('Augmented-Major 7th', '1  3  ♯5  7',       [0, 4, 8, 11]),
    _Quality('Dominant 9th',        '1  3  5  ♭7  9',    [0, 4, 7, 10, 14]),
    _Quality('Major 9th',           '1  3  5  7  9',     [0, 4, 7, 11, 14]),
    _Quality('Minor 9th',           '1  ♭3  5  ♭7  9',   [0, 3, 7, 10, 14]),
];

class _ChordQualitiesWidgetState extends State<ChordQualitiesWidget> {
  int _rootIndex = 0;
  int? _expanded;

  String _noteAt(int semitones) =>
      _chromatic[(_rootIndex + semitones) % 12];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        // Root note picker
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _rootNames.length,
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (_, i) => ChoiceChip(
              label: Text(_rootNames[i]),
              selected: _rootIndex == i,
              onSelected: (_) => setState(() {
                _rootIndex = i;
              }),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Chord list
        Expanded(
          child: ListView.builder(
            itemCount: _qualities.length,
            itemBuilder: (_, i) {
              final q = _qualities[i];
              final isOpen = _expanded == i;
              final notes = q.intervals
                  .map((s) => _noteAt(s % 12))
                  .toList();

              return GestureDetector(
                onTap: () =>
                    setState(() => _expanded = isOpen ? null : i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: isOpen ? cs.primary : cs.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                q.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isOpen
                                      ? cs.onPrimary
                                      : cs.onPrimaryContainer,
                                ),
                              ),
                            ),
                            Text(
                              q.formula,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                                color: isOpen
                                    ? cs.onPrimary.withAlpha(200)
                                    : cs.primary,
                              ),
                            ),
                          ],
                        ),
                        if (isOpen) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: notes
                                .map((n) => Chip(
                                      label: Text(n,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: cs.onPrimary)),
                                      backgroundColor: cs.primary.withAlpha(180),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Quality {
  const _Quality(this.name, this.formula, this.intervals);
  final String name;
  final String formula;
  final List<int> intervals;
}
