import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../core/sequence_trainer/data/note_spelling.dart';
import '../../../core/sequence_trainer/domain/note_degree.dart';
import '../../../core/sequence_trainer/domain/note_sequence.dart';
import '../../../core/sequence_trainer/domain/sequence_direction.dart';
import '../../trainer/data/chord_data.dart';
import '../../trainer/domain/chord.dart';
import '../../trainer/domain/chord_type.dart';
import '../domain/arpeggio_inversion.dart';

/// Chord tones of every quality, filled by [initArpeggioData].
Map<ChordType, List<NoteDegree>> arpeggioData = {};

Future<void> initArpeggioData() async {
  final raw =
      await rootBundle.loadString('database/trainer/chord_qualities.json');
  final list = jsonDecode(raw) as List<dynamic>;

  final loaded = <ChordType, List<NoteDegree>>{};
  for (final entry in list) {
    final type = qualityToChordType[entry['id'] as String];
    if (type == null) continue;
    final formula = (entry['formula'] as List<dynamic>).cast<String>();
    final semitones = (entry['semitones'] as List<dynamic>).cast<int>();
    if (formula.length != semitones.length) continue;
    loaded[type] = [
      for (var i = 0; i < formula.length; i++)
        NoteDegree(_letterStepOf(formula[i]), semitones[i]),
    ];
  }

  arpeggioData = loaded;
}

/// The degree number in a formula entry says which letter the tone takes: `b3`
/// is a third, two letters above the root, `bb7` is six letters above. Reading
/// it from the formula is what keeps sus4 chords spelled C F G rather than in
/// thirds.
int _letterStepOf(String formulaDegree) {
  final digits = formulaDegree.replaceAll(RegExp(r'[^0-9]'), '');
  return (int.tryParse(digits) ?? 1) - 1;
}

/// Cumulative pool: every chord quality from level 1 up to [level].
///
/// Levels match the chord trainer, so level 6 is the same set of chords in both.
List<NoteSequence> buildArpeggioPool(
  int level,
  SequenceDirection direction, {
  required ArpeggioInversion inversion,
  required int octaves,
  required String Function(int inversion) inversionLabel,
  bool cumulative = true,
  bool naturalRootsOnly = true,
}) =>
    _buildPool(
      cumulative ? buildChordPool(level) : buildChordPoolSingle(level),
      direction,
      inversion,
      octaves,
      inversionLabel,
      naturalRootsOnly,
    );

/// Single-level pool: only the chord quality belonging to exactly [level].
List<NoteSequence> buildArpeggioPoolSingle(
  int level,
  SequenceDirection direction, {
  required ArpeggioInversion inversion,
  required int octaves,
  required String Function(int inversion) inversionLabel,
  bool naturalRootsOnly = true,
}) =>
    _buildPool(
      buildChordPoolSingle(level),
      direction,
      inversion,
      octaves,
      inversionLabel,
      naturalRootsOnly,
    );

List<NoteSequence> _buildPool(
  List<Chord> chords,
  SequenceDirection direction,
  ArpeggioInversion inversion,
  int octaves,
  String Function(int inversion) inversionLabel,
  bool naturalRootsOnly,
) {
  final pool = <NoteSequence>[];
  for (final chord in chords) {
    final tones = arpeggioData[chord.type];
    if (tones == null) continue;
    final root = chord.rootNote;
    if (naturalRootsOnly && root.length > 1) continue;

    for (final index in _inversionsOf(inversion, tones.length)) {
      final degrees = _spanning(_inverted(tones, index), octaves);
      pool.add(NoteSequence(
        id: '${chord.symbol}_${index}_$octaves',
        title: chord.symbol,
        subtitle: index == 0 ? null : inversionLabel(index),
        noteNames: orderedForDirection(spell(root, degrees), direction),
        pitchClasses: orderedForDirection(
          pitchClassesOf(root, degrees),
          direction,
        ),
      ));
    }
  }
  return List.unmodifiable(pool);
}

/// Random draws from every inversion the chord has, so seventh chords bring
/// their third inversion along.
List<int> _inversionsOf(ArpeggioInversion inversion, int toneCount) =>
    inversion == ArpeggioInversion.random
        ? [for (var i = 0; i < toneCount; i++) i]
        : [inversion.index.clamp(0, toneCount - 1)];

/// Rotates the chord tones so the arpeggio starts on the [inversion]th one, and
/// closes on that same tone an octave up: Cmaj7 first inversion is E G B C E.
List<NoteDegree> _inverted(List<NoteDegree> tones, int inversion) {
  final count = tones.length;
  final start = inversion % count;
  final rotated = [
    for (var i = 0; i < count; i++)
      if (start + i >= count) tones[start + i - count].octaveUp else tones[start + i],
  ];
  return [...rotated, rotated.first.octaveUp];
}

/// Repeats the run an octave higher, closing two octaves above the start.
List<NoteDegree> _spanning(List<NoteDegree> single, int octaves) {
  if (octaves <= 1) return single;
  final body = single.take(single.length - 1).toList();
  return [
    ...body,
    ...body.map((degree) => degree.octaveUp),
    body.first.octaveUp.octaveUp,
  ];
}
