import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/chord.dart';
import '../domain/chord_type.dart';

const _qualityToType = <String, ChordType>{
  'quality_major':    ChordType.major,
  'quality_minor':    ChordType.minor,
  'quality_aug':      ChordType.aug,
  'quality_dim':      ChordType.dim,
  'quality_sus4':     ChordType.sus,
  'quality_seventh':  ChordType.seventh,
  'quality_maj7':     ChordType.maj7,
  'quality_m7':       ChordType.m7,
  'quality_dim7':     ChordType.dim7,
  'quality_halfdim7': ChordType.halfDim7,
  'quality_mmaj7':    ChordType.mMaj7,
  'quality_augmaj7':  ChordType.augMaj7,
};

Map<ChordType, List<Chord>> chordData = {};

Future<void> initChordData() async {
  final raw = await rootBundle.loadString('database/trainer/chords.json');
  final list = jsonDecode(raw) as List<dynamic>;

  final grouped = <ChordType, List<Chord>>{
    for (final t in ChordType.values) t: [],
  };

  for (final entry in list) {
    final type = _qualityToType[entry['qualityId'] as String];
    if (type == null) continue;
    final names = (entry['displayNames'] as List<dynamic>).cast<String>();
    grouped[type]!.add(Chord(
      symbol:    names[0],
      altSymbol: names.length > 1 ? names[1] : null,
      type:      type,
    ));
  }

  chordData = grouped;
}

/// Returns the cumulative chord pool for levels 1..level (1-based).
List<Chord> buildChordPool(int level) {
  final types = ChordType.values;
  final pool = <Chord>[];
  final count = level.clamp(1, types.length);
  for (var i = 0; i < count; i++) {
    pool.addAll(chordData[types[i]]!);
  }
  return pool;
}

/// Returns only the chords for the exact level (1-based).
List<Chord> buildChordPoolSingle(int level) {
  final type = ChordType.values[(level - 1).clamp(0, ChordType.values.length - 1)];
  return List.of(chordData[type]!);
}
