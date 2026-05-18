import '../domain/chord.dart';
import '../domain/chord_type.dart';

List<Chord> _chordList(ChordType type, String suffix) => [
      Chord(symbol: 'C$suffix', type: type),
      Chord(symbol: 'C#$suffix', altSymbol: 'Db$suffix', type: type),
      Chord(symbol: 'D$suffix', type: type),
      Chord(symbol: 'D#$suffix', altSymbol: 'Eb$suffix', type: type),
      Chord(symbol: 'E$suffix', type: type),
      Chord(symbol: 'F$suffix', type: type),
      Chord(symbol: 'F#$suffix', altSymbol: 'Gb$suffix', type: type),
      Chord(symbol: 'G$suffix', type: type),
      Chord(symbol: 'G#$suffix', altSymbol: 'Ab$suffix', type: type),
      Chord(symbol: 'A$suffix', type: type),
      Chord(symbol: 'A#$suffix', altSymbol: 'Bb$suffix', type: type),
      Chord(symbol: 'B$suffix', type: type),
    ];

final Map<ChordType, List<Chord>> chordData = {
  ChordType.major:    _chordList(ChordType.major,    ''),
  ChordType.minor:    _chordList(ChordType.minor,    'm'),
  ChordType.aug:      _chordList(ChordType.aug,      'aug'),
  ChordType.dim:      _chordList(ChordType.dim,      'dim'),
  ChordType.sus:      _chordList(ChordType.sus,      'sus'),
  ChordType.seventh:  _chordList(ChordType.seventh,  '7'),
  ChordType.maj7:     _chordList(ChordType.maj7,     'maj7'),
  ChordType.m7:       _chordList(ChordType.m7,       'm7'),
  ChordType.dim7:     _chordList(ChordType.dim7,     'dim7'),
  ChordType.halfDim7: _chordList(ChordType.halfDim7, 'm7b5'),
  ChordType.mMaj7:    _chordList(ChordType.mMaj7,    'mMaj7'),
  ChordType.augMaj7:  _chordList(ChordType.augMaj7,  'augMaj7'),
};

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
