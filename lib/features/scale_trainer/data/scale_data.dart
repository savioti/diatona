import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../core/sequence_trainer/data/note_spelling.dart';
import '../../../core/sequence_trainer/domain/note_degree.dart';
import '../../../core/sequence_trainer/domain/note_sequence.dart';
import '../../../core/sequence_trainer/domain/sequence_direction.dart';
import '../domain/scale_type.dart';

/// Semitone offsets of every scale type, filled by [initScaleData].
Map<ScaleType, List<int>> scaleData = {};

Future<void> initScaleData() async {
  final raw = await rootBundle.loadString('database/trainer/scales.json');
  final list = jsonDecode(raw) as List<dynamic>;
  final byId = {for (final t in ScaleType.values) t.id: t};

  final loaded = <ScaleType, List<int>>{};
  for (final entry in list) {
    final type = byId[entry['id'] as String];
    if (type == null) continue;
    loaded[type] = (entry['semitones'] as List<dynamic>).cast<int>();
  }

  scaleData = loaded;
}

/// Cumulative pool: every scale type from level 1 up to [level], in every key.
List<NoteSequence> buildScalePool(
  int level,
  SequenceDirection direction, {
  required String Function(ScaleType type, String root) title,
  bool naturalRootsOnly = true,
}) =>
    _buildPool(_typesUpTo(level), direction, naturalRootsOnly, title);

/// Single-level pool: only the scale type belonging to exactly [level].
List<NoteSequence> buildScalePoolSingle(
  int level,
  SequenceDirection direction, {
  required String Function(ScaleType type, String root) title,
  bool naturalRootsOnly = true,
}) =>
    _buildPool([_typeAt(level)], direction, naturalRootsOnly, title);

List<ScaleType> _typesUpTo(int level) =>
    ScaleType.values.take(level.clamp(1, ScaleType.values.length)).toList();

ScaleType _typeAt(int level) =>
    ScaleType.values[(level - 1).clamp(0, ScaleType.values.length - 1)];

List<NoteSequence> _buildPool(
  List<ScaleType> types,
  SequenceDirection direction,
  bool naturalRootsOnly,
  String Function(ScaleType type, String root) title,
) {
  final pool = <NoteSequence>[];
  for (final type in types) {
    final semitones = scaleData[type];
    if (semitones == null) continue;
    final degrees = _degreesOf(semitones);
    final roots = naturalRootsOnly
        ? naturalRoots
        : [for (final options in rootSpellings) bestRootSpelling(options, degrees)];
    for (final root in roots) {
      pool.add(NoteSequence(
        id: '${type.name}_$root',
        title: title(type, root),
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

/// One letter per degree, plus the closing octave, so a seven note scale is
/// eight notes to play.
List<NoteDegree> _degreesOf(List<int> semitones) => [
      for (var i = 0; i < semitones.length; i++) NoteDegree(i, semitones[i]),
      const NoteDegree(7, 12),
    ];
