import 'package:flutter/material.dart';

import '../../../../core/audio/chord_playback_service.dart';
import '../../../../core/harmony/data/harmony_data.dart';
import '../../../../core/harmony/data/voicing.dart';
import '../../../../core/harmony/domain/diatonic_chord.dart';
import '../../../../core/harmony/domain/harmonic_key.dart';
import '../../../../core/harmony/domain/progression_tempo.dart';
import '../../../../core/harmony/presentation/harmony_labels.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../scale_trainer/domain/scale_type.dart';
import '../../../scale_trainer/presentation/scale_labels.dart';

/// Which chords two keys have in common, and what each one is called on either
/// side of the change.
class ModulationWidget extends StatefulWidget {
  const ModulationWidget({super.key});

  @override
  State<ModulationWidget> createState() => _ModulationWidgetState();
}

class _ModulationWidgetState extends State<ModulationWidget> {
  final _piano = ChordPlaybackService();

  int _fromPitchClass = 0;
  ScaleType _fromScale = ScaleType.major;
  int _toPitchClass = 7;
  ScaleType _toScale = ScaleType.major;
  int? _playingDegree;

  @override
  void initState() {
    super.initState();
    _piano.init();
  }

  @override
  void dispose() {
    _piano.dispose();
    super.dispose();
  }

  /// A pivot only proves itself by leading somewhere, so it is played into the
  /// dominant and tonic of the key being arrived at.
  void _playPivot(DiatonicChord pivot, HarmonicKey to) {
    setState(() => _playingDegree = pivot.degree);
    _piano.playSequence(
      voiceProgression([pivot, chordAt(to, 5), chordAt(to, 1)]),
      millisPerChord: ProgressionTempo.medium.millis,
      onComplete: () {
        if (mounted) setState(() => _playingDegree = null);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final from = keyAt(_fromPitchClass, _fromScale);
    final to = keyAt(_toPitchClass, _toScale);
    final fromChords = buildDiatonicChords(from);
    final toChords = buildDiatonicChords(to);

    final pivots = <int, DiatonicChord>{
      for (final chord in fromChords)
        if (_matching(toChords, chord) != null)
          chord.degree: _matching(toChords, chord)!,
    };

    return ListView(
      children: [
        _KeyPicker(
          label: l10n.refModulationFrom,
          pitchClass: _fromPitchClass,
          scale: _fromScale,
          onChanged: (pc, scale) => setState(() {
            _fromPitchClass = pc;
            _fromScale = scale;
            _playingDegree = null;
          }),
          l10n: l10n,
        ),
        const SizedBox(height: 12),
        _KeyPicker(
          label: l10n.refModulationTo,
          pitchClass: _toPitchClass,
          scale: _toScale,
          onChanged: (pc, scale) => setState(() {
            _toPitchClass = pc;
            _toScale = scale;
            _playingDegree = null;
          }),
          l10n: l10n,
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${harmonicKeyName(from, l10n)}  →  '
                '${harmonicKeyName(to, l10n)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.refModulationDistance(
                  _fifthsBetween(_fromPitchClass, _toPitchClass),
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withAlpha(200),
                ),
              ),
              Text(
                l10n.refModulationSharedCount(pivots.length),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withAlpha(200),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final chord in fromChords)
              _PivotCell(
                chord: chord,
                arrival: pivots[chord.degree],
                playing: _playingDegree == chord.degree,
                onTap: pivots.containsKey(chord.degree)
                    ? () => _playPivot(chord, to)
                    : null,
                theme: theme,
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          pivots.isEmpty
              ? l10n.refModulationNoPivots
              : l10n.refModulationTapPivot,
          style: theme.textTheme.bodySmall
              ?.copyWith(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  /// The same chord in the other key, matched by the notes rather than by the
  /// name: `Bbm` and `A#m` are one chord under two spellings.
  DiatonicChord? _matching(List<DiatonicChord> chords, DiatonicChord chord) {
    final wanted = chord.pitchClasses.toSet();
    for (final candidate in chords) {
      if (candidate.pitchClasses.toSet().containsAll(wanted) &&
          candidate.pitchClasses.length == chord.pitchClasses.length) {
        return candidate;
      }
    }
    return null;
  }

  /// How many fifths apart the two tonics are, the short way round.
  int _fifthsBetween(int from, int to) {
    for (var steps = 0; steps < 12; steps++) {
      if ((from + 7 * steps) % 12 == to % 12) {
        return steps <= 6 ? steps : 12 - steps;
      }
    }
    return 0;
  }
}

class _KeyPicker extends StatelessWidget {
  const _KeyPicker({
    required this.label,
    required this.pitchClass,
    required this.scale,
    required this.onChanged,
    required this.l10n,
  });

  final String label;
  final int pitchClass;
  final ScaleType scale;
  final void Function(int pitchClass, ScaleType scale) onChanged;
  final AppLocalizations l10n;

  static const _scales = [ScaleType.major, ScaleType.naturalMinor];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: theme.textTheme.titleSmall),
            const SizedBox(width: 12),
            for (final option in _scales) ...[
              ChoiceChip(
                label: Text(scaleTypeName(option, l10n)),
                selected: scale == option,
                onSelected: (_) => onChanged(pitchClass, option),
              ),
              const SizedBox(width: 6),
            ],
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (_, i) => ChoiceChip(
              label: Text(keyAt(i, scale).root),
              selected: pitchClass == i,
              onSelected: (_) => onChanged(i, scale),
            ),
          ),
        ),
      ],
    );
  }
}

class _PivotCell extends StatelessWidget {
  const _PivotCell({
    required this.chord,
    required this.arrival,
    required this.playing,
    required this.onTap,
    required this.theme,
  });

  final DiatonicChord chord;

  /// The same chord as the key being arrived at names it, null when the key
  /// being arrived at does not have this chord.
  final DiatonicChord? arrival;
  final bool playing;
  final VoidCallback? onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    final isPivot = arrival != null;

    final background = playing
        ? cs.primary
        : isPivot
            ? cs.primaryContainer
            : cs.surfaceContainerHighest.withAlpha(90);
    final foreground = playing
        ? cs.onPrimary
        : isPivot
            ? cs.onPrimaryContainer
            : cs.onSurface.withAlpha(110);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        constraints: const BoxConstraints(minWidth: 78),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPivot ? cs.primary.withAlpha(120) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              chord.symbol,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: foreground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              arrival == null
                  ? chord.numeral
                  : '${chord.numeral} → ${arrival!.numeral}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: foreground,
                fontWeight: isPivot ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
