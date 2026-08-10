import 'dart:convert';
import 'dart:io';

import 'package:diatona/core/harmony/data/harmony_data.dart';
import 'package:diatona/core/harmony/data/progression_data.dart';
import 'package:diatona/core/sequence_trainer/domain/note_degree.dart';
import 'package:diatona/core/sequence_trainer/domain/note_sequence.dart';
import 'package:diatona/features/arpeggio_trainer/data/arpeggio_data.dart';
import 'package:diatona/features/scale_trainer/data/scale_data.dart';
import 'package:diatona/features/scale_trainer/domain/scale_type.dart';
import 'package:diatona/features/trainer/data/chord_data.dart';
import 'package:diatona/features/trainer/domain/chord.dart';
import 'package:diatona/features/trainer/domain/chord_type.dart';

/// Fills the data maps from the JSON files the app bundles, without going
/// through rootBundle, which is not available to plain unit tests.

List<dynamic> _read(String path) =>
    jsonDecode(File(path).readAsStringSync()) as List<dynamic>;

void loadScaleDataFromDisk() {
  final byId = {for (final t in ScaleType.values) t.id: t};
  scaleData = {
    for (final entry in _read('database/trainer/scales.json'))
      if (byId[entry['id'] as String] != null)
        byId[entry['id'] as String]!:
            (entry['semitones'] as List<dynamic>).cast<int>(),
  };
}

void loadChordDataFromDisk() {
  final grouped = <ChordType, List<Chord>>{
    for (final t in ChordType.values) t: [],
  };
  for (final entry in _read('database/trainer/chords.json')) {
    final type = qualityToChordType[entry['qualityId'] as String];
    if (type == null) continue;
    final names = (entry['displayNames'] as List<dynamic>).cast<String>();
    grouped[type]!.add(Chord(
      symbol: names[0],
      altSymbol: names.length > 1 ? names[1] : null,
      type: type,
    ));
  }
  chordData = grouped;
}

void loadArpeggioDataFromDisk() {
  final loaded = <ChordType, List<NoteDegree>>{};
  for (final entry in _read('database/trainer/chord_qualities.json')) {
    final type = qualityToChordType[entry['id'] as String];
    if (type == null) continue;
    final formula = (entry['formula'] as List<dynamic>).cast<String>();
    final semitones = (entry['semitones'] as List<dynamic>).cast<int>();
    loaded[type] = [
      for (var i = 0; i < formula.length; i++)
        NoteDegree(
          (int.tryParse(formula[i].replaceAll(RegExp(r'[^0-9]'), '')) ?? 1) - 1,
          semitones[i],
        ),
    ];
  }
  arpeggioData = loaded;
}

/// The harmony maps read the scale degrees, so [loadScaleDataFromDisk] has to
/// have run before this does.
void loadHarmonyDataFromDisk() {
  loadHarmonyData(
    scales: _read('database/trainer/scales.json'),
    qualities: _read('database/trainer/chord_qualities.json'),
  );
}

void loadProgressionDataFromDisk() {
  loadProgressionData(
    jsonDecode(File('database/trainer/progressions.json').readAsStringSync())
        as Map<String, dynamic>,
  );
}

NoteSequence byTitle(List<NoteSequence> pool, String title) =>
    pool.firstWhere((s) => s.title == title);
