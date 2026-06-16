import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';

// ── Harmony map data ─────────────────────────────────────────────────────────
const _keyNames  = ['C', 'G', 'D', 'A', 'E', 'B', 'F♯', 'D♭', 'A♭', 'E♭', 'B♭', 'F'];
const _keyRoots  = [0, 7, 2, 9, 4, 11, 6, 1, 8, 3, 10, 5];
const _allNotes  = ['C', 'C♯', 'D', 'E♭', 'E', 'F', 'F♯', 'G', 'A♭', 'A', 'B♭', 'B'];
const _intervals = [0, 2, 4, 5, 7, 9, 11];
const _qualities = ['maj', 'min', 'min', 'maj', 'dom', 'min', 'dim'];
const _romans    = ['I', 'ii', 'iii', 'IV', 'V', 'vi', 'vii°'];
const _functions = ['Tonic', 'Subdominant', 'Tonic', 'Subdominant', 'Dominant', 'Tonic', 'Dominant'];
const _functionDesc = [
  'Rest & home base',
  'Departure & motion',
  'Tonic color',
  'Departure & pre-dominant',
  'Tension — resolves to I',
  'Tonic substitute',
  'Strong tension, like V7',
];

class HarmonyMapWidget extends StatefulWidget {
  const HarmonyMapWidget({super.key});

  @override
  State<HarmonyMapWidget> createState() => _HarmonyMapWidgetState();
}

class _HarmonyMapWidgetState extends State<HarmonyMapWidget> {
  int _keyIndex = 0;
  int? _selected;

  String _chordName(int degreeIdx) {
    final root = (_keyRoots[_keyIndex] + _intervals[degreeIdx]) % 12;
    final noteName = _allNotes[root];
    return switch (_qualities[degreeIdx]) {
      'min' => '${noteName}m',
      'dim' => '$noteName°',
      _ => noteName,
    };
  }

  Color _functionColor(BuildContext context, int i) {
    final cs = Theme.of(context).colorScheme;
    return switch (_functions[i]) {
      'Tonic' => cs.primary,
      'Subdominant' => cs.secondary,
      _ => cs.tertiary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        // Key picker
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _keyNames.length,
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (_, i) => ChoiceChip(
              label: Text(_keyNames[i]),
              selected: _keyIndex == i,
              onSelected: (_) => setState(() {
                _keyIndex = i;
                _selected = null;
              }),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Chord degree grid
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemCount: 7,
            itemBuilder: (context, i) {
              final isSelected = _selected == i;
              final fnColor = _functionColor(context, i);
              return GestureDetector(
                onTap: () => setState(
                    () => _selected = _selected == i ? null : i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? fnColor.withAlpha(230)
                        : cs.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: fnColor.withAlpha(isSelected ? 0 : 120),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _romans[i],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? _colorOn(fnColor)
                              : cs.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _chordName(i),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? _colorOn(fnColor)
                              : cs.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withAlpha(50)
                              : fnColor.withAlpha(40),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _functions[i],
                          style: TextStyle(
                            fontSize: 9,
                            color: isSelected
                                ? _colorOn(fnColor)
                                : fnColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Detail panel
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _selected == null
              ? Padding(
                  key: const ValueKey('hint'),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    AppLocalizations.of(context).refTapChordFunction,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(fontStyle: FontStyle.italic),
                  ),
                )
              : Container(
                  key: ValueKey(_selected),
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_romans[_selected!]} (${_chordName(_selected!)}) — '
                    '${_functions[_selected!]}: ${_functionDesc[_selected!]}',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ],
    );
  }

  Color _colorOn(Color bg) =>
      bg.computeLuminance() > 0.35 ? const Color(0xFF1A1A1A) : Colors.white;
}
