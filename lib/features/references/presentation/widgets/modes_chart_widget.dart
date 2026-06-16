import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';

class ModesChartWidget extends StatefulWidget {
  const ModesChartWidget({super.key});

  @override
  State<ModesChartWidget> createState() => _ModesChartWidgetState();
}

// ── Modes data ───────────────────────────────────────────────────────────────
const _modes = [
    _Mode(
      name: 'Ionian',
      altName: '(Major)',
      degree: 'I',
      formula: 'W – W – H – W – W – W – H',
      characteristic: 'Raised 4th vs nothing unique',
      mood: 'Happy, bright, stable',
      example: 'C D E F G A B',
      parentKey: 'C Major',
      startNote: 'C',
    ),
    _Mode(
      name: 'Dorian',
      altName: '(minor ♮6)',
      degree: 'II',
      formula: 'W – H – W – W – W – H – W',
      characteristic: 'Natural 6th (vs Aeolian ♭6)',
      mood: 'Minor but hopeful, funky, jazzy',
      example: 'D E F G A B C\n= C Major from D',
      parentKey: 'C Major',
      startNote: 'D',
    ),
    _Mode(
      name: 'Phrygian',
      altName: '(minor ♭2)',
      degree: 'III',
      formula: 'H – W – W – W – H – W – W',
      characteristic: 'Flat 2nd — the Spanish sound',
      mood: 'Dark, exotic, flamenco',
      example: 'E F G A B C D\n= C Major from E',
      parentKey: 'C Major',
      startNote: 'E',
    ),
    _Mode(
      name: 'Lydian',
      altName: '(Major ♯4)',
      degree: 'IV',
      formula: 'W – W – W – H – W – W – H',
      characteristic: 'Raised 4th — the dreamy tritone',
      mood: 'Dreamy, floating, ethereal',
      example: 'F G A B C D E\n= C Major from F',
      parentKey: 'C Major',
      startNote: 'F',
    ),
    _Mode(
      name: 'Mixolydian',
      altName: '(dominant ♭7)',
      degree: 'V',
      formula: 'W – W – H – W – W – H – W',
      characteristic: 'Flat 7th (vs Ionian natural 7th)',
      mood: 'Bluesy, rock, dominant groove',
      example: 'G A B C D E F\n= C Major from G',
      parentKey: 'C Major',
      startNote: 'G',
    ),
    _Mode(
      name: 'Aeolian',
      altName: '(Natural Minor)',
      degree: 'VI',
      formula: 'W – H – W – W – H – W – W',
      characteristic: 'Flat 3rd, 6th and 7th',
      mood: 'Sad, melancholic, introspective',
      example: 'A B C D E F G\n= C Major from A',
      parentKey: 'C Major',
      startNote: 'A',
    ),
    _Mode(
      name: 'Locrian',
      altName: '(diminished ♭2 ♭5)',
      degree: 'VII',
      formula: 'H – W – W – H – W – W – W',
      characteristic: 'Flat 2nd AND flat 5th — unstable',
      mood: 'Tense, dissonant, rarely used melodically',
      example: 'B C D E F G A\n= C Major from B',
      parentKey: 'C Major',
      startNote: 'B',
    ),
];

class _ModesChartWidgetState extends State<ModesChartWidget> {
  int _modeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final mode = _modes[_modeIndex];

    return Column(
      children: [
        // Mode selector chips
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _modes.length,
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (_, i) => ChoiceChip(
              label: Text(_modes[i].name),
              selected: _modeIndex == i,
              onSelected: (_) => setState(() => _modeIndex = i),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Mode detail card
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position:
                    Tween(begin: const Offset(0.05, 0), end: Offset.zero)
                        .animate(anim),
                child: child,
              ),
            ),
            child: _ModeCard(
              key: ValueKey(_modeIndex),
              mode: mode,
              cs: cs,
              theme: theme,
            ),
          ),
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    super.key,
    required this.mode,
    required this.cs,
    required this.theme,
  });

  final _Mode mode;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    mode.degree,
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: cs.onPrimary),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mode.name,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text(mode.altName,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: cs.primary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            _Row(label: AppLocalizations.of(context).refModeFormula, value: mode.formula, theme: theme, cs: cs),
            _Row(
                label: AppLocalizations.of(context).refModeCharacteristic,
                value: mode.characteristic,
                theme: theme,
                cs: cs),
            _Row(label: AppLocalizations.of(context).refModeMood, value: mode.mood, theme: theme, cs: cs),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context).refScaleNotesFrom(mode.startNote, mode.parentKey),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: cs.onPrimaryContainer.withAlpha(160))),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                mode.example,
                style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace', fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(
      {required this.label,
      required this.value,
      required this.theme,
      required this.cs});

  final String label;
  final String value;
  final ThemeData theme;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onPrimaryContainer.withAlpha(160))),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _Mode {
  const _Mode({
    required this.name,
    required this.altName,
    required this.degree,
    required this.formula,
    required this.characteristic,
    required this.mood,
    required this.example,
    required this.parentKey,
    required this.startNote,
  });

  final String name;
  final String altName;
  final String degree;
  final String formula;
  final String characteristic;
  final String mood;
  final String example;
  final String parentKey;
  final String startNote;
}
