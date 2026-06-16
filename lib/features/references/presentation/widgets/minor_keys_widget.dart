import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';

// ── Minor keys data ──────────────────────────────────────────────────────────
const _keyNames  = ['A', 'E', 'B', 'F♯', 'C♯', 'G♯', 'D♯', 'B♭', 'F', 'C', 'G', 'D'];
const _keyRoots  = [9, 4, 11, 6, 1, 8, 3, 10, 5, 0, 7, 2];
const _chromatic = ['C', 'C♯', 'D', 'E♭', 'E', 'F', 'F♯', 'G', 'A♭', 'A', 'B♭', 'B'];
// Intervals for each scale type (semitones from root)
const _natural  = [0, 2, 3, 5, 7, 8, 10];
const _harmonic = [0, 2, 3, 5, 7, 8, 11]; // ♯7
const _melodic  = [0, 2, 3, 5, 7, 9, 11]; // ♯6 ♯7
// Degrees that are raised vs natural minor (for highlighting)
const _harmonicAltered = {6};    // 7th degree
const _melodicAltered  = {5, 6}; // 6th and 7th degrees
const _degreeLabels = ['1', '2', '♭3', '4', '5', '6', '7', '8'];

class MinorKeysWidget extends StatefulWidget {
  const MinorKeysWidget({super.key});

  @override
  State<MinorKeysWidget> createState() => _MinorKeysWidgetState();
}

class _MinorKeysWidgetState extends State<MinorKeysWidget>
    with SingleTickerProviderStateMixin {
  int _keyIndex = 0;
  late final TabController _tabs;

  List<int> _intervals(int tabIndex) => switch (tabIndex) {
        1 => _harmonic,
        2 => _melodic,
        _ => _natural,
      };

  Set<int> _altered(int tabIndex) => switch (tabIndex) {
        1 => _harmonicAltered,
        2 => _melodicAltered,
        _ => const {},
      };

  String _noteName(int root, int semitones) =>
      _chromatic[(root + semitones) % 12];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _tabs.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final root = _keyRoots[_keyIndex];
    final tabIndex = _tabs.index;
    final intervals = _intervals(tabIndex);
    final altered = _altered(tabIndex);

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
              label: Text('${_keyNames[i]}m'),
              selected: _keyIndex == i,
              onSelected: (_) => setState(() => _keyIndex = i),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Scale type tabs
        TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: AppLocalizations.of(context).refMinorNatural),
            Tab(text: AppLocalizations.of(context).refMinorHarmonic),
            Tab(text: AppLocalizations.of(context).refMinorMelodic),
          ],
          labelColor: cs.primary,
          unselectedLabelColor: cs.onSurface.withAlpha(150),
          indicatorColor: cs.primary,
        ),
        const SizedBox(height: 16),
        // Scale note row
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _ScaleRow(
            key: ValueKey('$_keyIndex-$tabIndex'),
            root: root,
            intervals: intervals,
            altered: altered,
            noteName: _noteName,
            cs: cs,
            theme: theme,
          ),
        ),
        const SizedBox(height: 16),
        // Alteration explanation
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _ExplanationBox(
            key: ValueKey(tabIndex),
            tabIndex: tabIndex,
            keyName: _keyNames[_keyIndex],
            cs: cs,
            theme: theme,
          ),
        ),
      ],
    );
  }
}

class _ScaleRow extends StatelessWidget {
  const _ScaleRow({
    super.key,
    required this.root,
    required this.intervals,
    required this.altered,
    required this.noteName,
    required this.cs,
    required this.theme,
  });

  final int root;
  final List<int> intervals;
  final Set<int> altered;
  final String Function(int, int) noteName;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(8, (i) {
          final note = i < 7
              ? noteName(root, intervals[i])
              : noteName(root, 0); // octave root
          final isAltered = altered.contains(i);
          final isRoot = i == 0 || i == 7;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _degreeLabels[i],
                  style: TextStyle(
                    fontSize: 10,
                    color: isAltered
                        ? cs.tertiary
                        : isRoot
                            ? cs.primary
                            : cs.onSurface.withAlpha(130),
                    fontWeight: isAltered ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isRoot
                        ? cs.primary
                        : isAltered
                            ? cs.tertiary.withAlpha(200)
                            : cs.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isAltered
                          ? cs.tertiary
                          : cs.onPrimaryContainer.withAlpha(40),
                      width: isAltered ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      note,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isRoot
                            ? cs.onPrimary
                            : isAltered
                                ? cs.onTertiary
                                : cs.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                if (isAltered) ...[
                  const SizedBox(height: 2),
                  Icon(Icons.arrow_upward_rounded,
                      size: 10, color: cs.tertiary),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ExplanationBox extends StatelessWidget {
  const _ExplanationBox({
    super.key,
    required this.tabIndex,
    required this.keyName,
    required this.cs,
    required this.theme,
  });

  final int tabIndex;
  final String keyName;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final text = switch (tabIndex) {
      1 => 'Harmonic Minor: raise the 7th degree by a half step.\n'
          'This creates a leading tone that resolves strongly to the root, '
          'and turns the v chord into a V7 (dominant 7th).',
      2 => 'Melodic Minor (ascending): raise both the 6th and 7th degrees.\n'
          'This avoids the awkward augmented 2nd interval that Harmonic Minor '
          'creates between ♭6 and ♯7.',
      _ => 'Natural Minor: the key signature as-is — no alterations.\n'
          'Same as the Aeolian mode. '
          '${keyName}m natural minor uses the same notes as its relative major.',
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: theme.textTheme.bodySmall),
    );
  }
}
