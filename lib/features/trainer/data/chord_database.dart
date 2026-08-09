import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/chord_type.dart';

const _typeToQualityId = <ChordType, String>{
  ChordType.major:    'quality_major',
  ChordType.minor:    'quality_minor',
  ChordType.aug:      'quality_aug',
  ChordType.dim:      'quality_dim',
  ChordType.sus:      'quality_sus4',
  ChordType.seventh:  'quality_seventh',
  ChordType.maj7:     'quality_maj7',
  ChordType.m7:       'quality_m7',
  ChordType.dim7:     'quality_dim7',
  ChordType.halfDim7: 'quality_halfdim7',
  ChordType.mMaj7:    'quality_mmaj7',
  ChordType.augMaj7:  'quality_augmaj7',
};

const _noteNameToId = <String, String>{
  'C':  'note_c',
  'C#': 'note_csharp',
  'Db': 'note_csharp',
  'D':  'note_d',
  'D#': 'note_dsharp',
  'Eb': 'note_dsharp',
  'E':  'note_e',
  'F':  'note_f',
  'F#': 'note_fsharp',
  'Gb': 'note_fsharp',
  'G':  'note_g',
  'G#': 'note_gsharp',
  'Ab': 'note_gsharp',
  'A':  'note_a',
  'A#': 'note_asharp',
  'Bb': 'note_asharp',
  'B':  'note_b',
};

class ChordDbEntry {
  const ChordDbEntry({
    required this.id,
    required this.trebleClefNotes,
    required this.bassClefNotes,
  });

  final String id;
  final List<String> trebleClefNotes;
  final List<String> bassClefNotes;
}

class ChordVoicing {
  const ChordVoicing({
    required this.numStrings,
    required this.frets,
    required this.fingers,
    required this.baseFret,
  });

  /// Fret values: int 0 = open, int n = nth relative fret, String 'x' = muted.
  /// Indexed low-string to high-string (index 0 = lowest pitch).
  final int numStrings;
  final List<dynamic> frets;
  final List<int?> fingers;
  final int baseFret;
}

class ChordDatabase {
  ChordDatabase._();

  static final ChordDatabase instance = ChordDatabase._();

  // key: '${qualityId}_${rootNoteId}'
  final _entries = <String, ChordDbEntry>{};
  // key: '${instrument}_${chordId}'
  final _voicings = <String, ChordVoicing>{};

  Future<void>? _loadFuture;

  Future<void> ensureLoaded() {
    _loadFuture ??= _load();
    return _loadFuture!;
  }

  Future<void> _load() async {
    final chordsRaw = await rootBundle.loadString('database/trainer/chords.json');
    final voicingsRaw = await rootBundle.loadString('database/trainer/voicings.json');

    final chordsList =
        (jsonDecode(chordsRaw) as List).cast<Map<String, dynamic>>();
    for (final c in chordsList) {
      final rawSpellings = c['spellings'] as List?;
      if (rawSpellings == null || rawSpellings.isEmpty) continue;
      final spellings = rawSpellings.cast<Map<String, dynamic>>();
      final staffRaw = spellings[0]['staff'] as Map<String, dynamic>?;
      if (staffRaw == null) continue;
      final treble = staffRaw['trebleClef'] as List?;
      final bass = staffRaw['bassClef'] as List?;
      if (treble == null || bass == null) continue;
      final key = '${c['qualityId']}_${c['rootNoteId']}';
      _entries[key] = ChordDbEntry(
        id: c['id'] as String,
        trebleClefNotes: treble.cast<String>(),
        bassClefNotes: bass.cast<String>(),
      );
    }

    final voicingsList =
        (jsonDecode(voicingsRaw) as List).cast<Map<String, dynamic>>();
    for (final v in voicingsList) {
      final isDefault = v['isDefault'] as bool? ?? false;
      if (!isDefault) continue;
      final rawFrets = v['frets'] as List?;
      final rawFingers = v['fingers'] as List?;
      final baseFret = v['baseFret'] as int?;
      if (rawFrets == null || rawFingers == null || baseFret == null) continue;
      final instrument = v['instrument'] as String? ?? '';
      final chordId = v['chordId'] as String? ?? '';
      if (instrument.isEmpty || chordId.isEmpty) continue;
      final key = '${instrument}_$chordId';
      if (_voicings.containsKey(key)) continue;
      final fingers = rawFingers.map((f) => f as int?).toList();
      _voicings[key] = ChordVoicing(
        numStrings: rawFrets.length,
        frets: rawFrets,
        fingers: fingers,
        baseFret: baseFret,
      );
    }
  }

  ChordDbEntry? lookupEntry(ChordType type, String rootNote) {
    final qualityId = _typeToQualityId[type];
    if (qualityId == null) return null;
    final noteId = _noteNameToId[rootNote];
    if (noteId == null) return null;
    return _entries['${qualityId}_$noteId'];
  }

  ChordVoicing? lookupVoicing(
      String instrument, ChordType type, String rootNote) {
    final entry = lookupEntry(type, rootNote);
    if (entry == null) return null;
    return _voicings['${instrument}_${entry.id}'];
  }
}
