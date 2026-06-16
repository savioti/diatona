import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';

// ── Scale formula data ───────────────────────────────────────────────────────
const _scaleNames = [
  ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'C'],           // C
  ['D♭', 'E♭', 'F', 'G♭', 'A♭', 'B♭', 'C', 'D♭'],    // D♭
  ['D', 'E', 'F♯', 'G', 'A', 'B', 'C♯', 'D'],         // D
  ['E♭', 'F', 'G', 'A♭', 'B♭', 'C', 'D', 'E♭'],       // E♭
  ['E', 'F♯', 'G♯', 'A', 'B', 'C♯', 'D♯', 'E'],       // E
  ['F', 'G', 'A', 'B♭', 'C', 'D', 'E', 'F'],           // F
  ['G♭', 'A♭', 'B♭', 'C♭', 'D♭', 'E♭', 'F', 'G♭'],   // G♭/F♯
  ['G', 'A', 'B', 'C', 'D', 'E', 'F♯', 'G'],           // G
  ['A♭', 'B♭', 'C', 'D♭', 'E♭', 'F', 'G', 'A♭'],      // A♭
  ['A', 'B', 'C♯', 'D', 'E', 'F♯', 'G♯', 'A'],         // A
  ['B♭', 'C', 'D', 'E♭', 'F', 'G', 'A', 'B♭'],         // B♭
  ['B', 'C♯', 'D♯', 'E', 'F♯', 'G♯', 'A♯', 'B'],       // B
];
const _rootNames     = ['C', 'D♭', 'D', 'E♭', 'E', 'F', 'G♭', 'G', 'A♭', 'A', 'B♭', 'B'];
// W W H W W W H between scale degrees 0→7
const _steps         = ['W', 'W', 'H', 'W', 'W', 'W', 'H'];
const _degreeLabels  = ['1', '2', '3', '4', '5', '6', '7', '8'];

class ScaleFormulaWidget extends StatefulWidget {
  const ScaleFormulaWidget({super.key});

  @override
  State<ScaleFormulaWidget> createState() => _ScaleFormulaWidgetState();
}

class _ScaleFormulaWidgetState extends State<ScaleFormulaWidget> {
  int _rootIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final scale = _scaleNames[_rootIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
              onSelected: (_) => setState(() => _rootIndex = i),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Formula banner
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: cs.primary.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'W – W – H – W – W – W – H',
            style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: cs.primary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        // Scale steps visualization
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Row(
                key: ValueKey(_rootIndex),
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(8, (i) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _NoteBox(
                        note: scale[i],
                        degree: _degreeLabels[i],
                        isRoot: i == 0 || i == 7,
                        cs: cs,
                        theme: theme,
                      ),
                      if (i < 7)
                        _StepArrow(
                          step: _steps[i],
                          cs: cs,
                          theme: theme,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Step legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Legend(label: AppLocalizations.of(context).refWholeStepLegend, cs: cs, theme: theme),
            const SizedBox(width: 16),
            _Legend(label: AppLocalizations.of(context).refHalfStepLegend, cs: cs, theme: theme),
          ],
        ),
      ],
    );
  }
}

class _NoteBox extends StatelessWidget {
  const _NoteBox({
    required this.note,
    required this.degree,
    required this.isRoot,
    required this.cs,
    required this.theme,
  });

  final String note;
  final String degree;
  final bool isRoot;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(degree,
            style: TextStyle(
                fontSize: 10,
                color: isRoot ? cs.primary : cs.onSurface.withAlpha(140))),
        const SizedBox(height: 4),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isRoot ? cs.primary : cs.primaryContainer,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isRoot ? cs.primary : cs.onPrimaryContainer.withAlpha(60),
            ),
          ),
          child: Center(
            child: Text(
              note,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isRoot ? cs.onPrimary : cs.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepArrow extends StatelessWidget {
  const _StepArrow(
      {required this.step, required this.cs, required this.theme});

  final String step;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isHalf = step == 'H';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          step,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isHalf ? cs.tertiary : cs.secondary,
          ),
        ),
        const SizedBox(height: 4),
        Icon(
          Icons.arrow_forward_rounded,
          size: 16,
          color: isHalf
              ? cs.tertiary.withAlpha(180)
              : cs.secondary.withAlpha(180),
        ),
        const SizedBox(height: 22), // align with box bottom
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend(
      {required this.label, required this.cs, required this.theme});

  final String label;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: theme.textTheme.bodySmall
            ?.copyWith(color: cs.onSurface.withAlpha(140)),
      );
}
