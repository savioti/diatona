import 'package:flutter/material.dart';

import '../../../../core/audio/chord_playback_service.dart';
import '../../../../core/harmony/data/harmony_data.dart';
import '../../../../core/harmony/data/progression_data.dart';
import '../../../../core/harmony/data/voicing.dart';
import '../../../../core/harmony/domain/chord_progression.dart';
import '../../../../core/harmony/domain/diatonic_chord.dart';
import '../../../../core/harmony/domain/progression_tempo.dart';
import '../../../../core/harmony/presentation/harmony_labels.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../scale_trainer/domain/scale_type.dart';

/// The progressions most songs are built from, rewritten into whichever key is
/// picked and playable on the piano samples.
class ProgressionsWidget extends StatefulWidget {
  const ProgressionsWidget({super.key});

  @override
  State<ProgressionsWidget> createState() => _ProgressionsWidgetState();
}

class _ProgressionsWidgetState extends State<ProgressionsWidget> {
  final _piano = ChordPlaybackService();

  int _pitchClass = 0;
  ProgressionTempo _tempo = ProgressionTempo.medium;
  bool _arpeggiate = false;

  /// Which progression is sounding, and how far into it playback has got.
  String? _playingId;
  int _playingIndex = -1;

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

  void _play(ChordProgression progression, List<DiatonicChord> chords) {
    if (_playingId == progression.id) {
      _piano.stop();
      setState(() {
        _playingId = null;
        _playingIndex = -1;
      });
      return;
    }

    setState(() {
      _playingId = progression.id;
      _playingIndex = 0;
    });

    _piano.playSequence(
      voiceProgression(chords),
      millisPerChord: _tempo.millis,
      arpeggiate: _arpeggiate,
      onChord: (index) {
        if (mounted && _playingId == progression.id) {
          setState(() => _playingIndex = index);
        }
      },
      onComplete: () {
        if (mounted && _playingId == progression.id) {
          setState(() {
            _playingId = null;
            _playingIndex = -1;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final keyNames = harmonicKeys(ScaleType.major, naturalRootsOnly: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: keyNames.length,
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (_, i) => ChoiceChip(
              label: Text(keyNames[i].root),
              selected: _pitchClass == i,
              onSelected: (_) {
                _piano.stop();
                setState(() {
                  _pitchClass = i;
                  _playingId = null;
                  _playingIndex = -1;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final tempo in ProgressionTempo.values)
              ChoiceChip(
                label: Text(progressionTempoName(tempo, l10n)),
                selected: _tempo == tempo,
                onSelected: (_) => setState(() => _tempo = tempo),
              ),
            const SizedBox(width: 4),
            FilterChip(
              label: Text(l10n.refProgressionsArpeggiate),
              selected: _arpeggiate,
              onSelected: (v) => setState(() => _arpeggiate = v),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: progressionData.length,
            itemBuilder: (context, i) {
              final progression = progressionData[i];
              final key = keyAt(_pitchClass, progression.scale);
              final chords = realizeProgression(progression, key.root);
              return _ProgressionCard(
                progression: progression,
                keyLabel: harmonicKeyName(key, l10n),
                chords: chords,
                isPlaying: _playingId == progression.id,
                playingIndex:
                    _playingId == progression.id ? _playingIndex : -1,
                onPlay: () => _play(progression, chords),
                theme: theme,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProgressionCard extends StatelessWidget {
  const _ProgressionCard({
    required this.progression,
    required this.keyLabel,
    required this.chords,
    required this.isPlaying,
    required this.playingIndex,
    required this.onPlay,
    required this.theme,
  });

  final ChordProgression progression;
  final String keyLabel;
  final List<DiatonicChord> chords;
  final bool isPlaying;
  final int playingIndex;
  final VoidCallback onPlay;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 6, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        progression.name,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        keyLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withAlpha(160),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  icon: Icon(
                    isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  ),
                  onPressed: onPlay,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < chords.length; i++)
                  _ChordCell(
                    chord: chords[i],
                    highlighted: i == playingIndex,
                    theme: theme,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChordCell extends StatelessWidget {
  const _ChordCell({
    required this.chord,
    required this.highlighted,
    required this.theme,
  });

  final DiatonicChord chord;
  final bool highlighted;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      constraints: const BoxConstraints(minWidth: 56),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: highlighted ? cs.primary : cs.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            chord.numeral,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: highlighted
                  ? cs.onPrimary
                  : cs.onPrimaryContainer.withAlpha(170),
            ),
          ),
          Text(
            chord.symbol,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: highlighted ? cs.onPrimary : cs.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
