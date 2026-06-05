import '../domain/note_clef.dart';
import '../domain/note_item.dart';

// Treble clef: C4–G5.
// Naturals + both sharp and flat spellings of each accidental are included as
// separate entries because they sit at different staff positions and look
// different — exactly what a beginner needs to practise.
const _trebleNotes = [
  // ── Octave 4 (C4 = one ledger below staff, B4 = third line) ──────────────
  NoteItem(id: 't_c4',       pitchClass: 0,  name: 'C',  detectedName: 'C',  staffNote: 'C4'),
  NoteItem(id: 't_csharp4',  pitchClass: 1,  name: 'C#', detectedName: 'C#', staffNote: 'C#4'),
  NoteItem(id: 't_db4',      pitchClass: 1,  name: 'Db', detectedName: 'C#', staffNote: 'Db4'),
  NoteItem(id: 't_d4',       pitchClass: 2,  name: 'D',  detectedName: 'D',  staffNote: 'D4'),
  NoteItem(id: 't_dsharp4',  pitchClass: 3,  name: 'D#', detectedName: 'D#', staffNote: 'D#4'),
  NoteItem(id: 't_eb4',      pitchClass: 3,  name: 'Eb', detectedName: 'D#', staffNote: 'Eb4'),
  NoteItem(id: 't_e4',       pitchClass: 4,  name: 'E',  detectedName: 'E',  staffNote: 'E4'),
  NoteItem(id: 't_f4',       pitchClass: 5,  name: 'F',  detectedName: 'F',  staffNote: 'F4'),
  NoteItem(id: 't_fsharp4',  pitchClass: 6,  name: 'F#', detectedName: 'F#', staffNote: 'F#4'),
  NoteItem(id: 't_gb4',      pitchClass: 6,  name: 'Gb', detectedName: 'F#', staffNote: 'Gb4'),
  NoteItem(id: 't_g4',       pitchClass: 7,  name: 'G',  detectedName: 'G',  staffNote: 'G4'),
  NoteItem(id: 't_gsharp4',  pitchClass: 8,  name: 'G#', detectedName: 'G#', staffNote: 'G#4'),
  NoteItem(id: 't_ab4',      pitchClass: 8,  name: 'Ab', detectedName: 'G#', staffNote: 'Ab4'),
  NoteItem(id: 't_a4',       pitchClass: 9,  name: 'A',  detectedName: 'A',  staffNote: 'A4'),
  NoteItem(id: 't_asharp4',  pitchClass: 10, name: 'A#', detectedName: 'A#', staffNote: 'A#4'),
  NoteItem(id: 't_bb4',      pitchClass: 10, name: 'Bb', detectedName: 'A#', staffNote: 'Bb4'),
  NoteItem(id: 't_b4',       pitchClass: 11, name: 'B',  detectedName: 'B',  staffNote: 'B4'),
  // ── Octave 5 (C5 = third space, F5 = top line, G5 = one step above) ──────
  NoteItem(id: 't_c5',       pitchClass: 0,  name: 'C',  detectedName: 'C',  staffNote: 'C5'),
  NoteItem(id: 't_csharp5',  pitchClass: 1,  name: 'C#', detectedName: 'C#', staffNote: 'C#5'),
  NoteItem(id: 't_db5',      pitchClass: 1,  name: 'Db', detectedName: 'C#', staffNote: 'Db5'),
  NoteItem(id: 't_d5',       pitchClass: 2,  name: 'D',  detectedName: 'D',  staffNote: 'D5'),
  NoteItem(id: 't_dsharp5',  pitchClass: 3,  name: 'D#', detectedName: 'D#', staffNote: 'D#5'),
  NoteItem(id: 't_eb5',      pitchClass: 3,  name: 'Eb', detectedName: 'D#', staffNote: 'Eb5'),
  NoteItem(id: 't_e5',       pitchClass: 4,  name: 'E',  detectedName: 'E',  staffNote: 'E5'),
  NoteItem(id: 't_f5',       pitchClass: 5,  name: 'F',  detectedName: 'F',  staffNote: 'F5'),
  NoteItem(id: 't_fsharp5',  pitchClass: 6,  name: 'F#', detectedName: 'F#', staffNote: 'F#5'),
  NoteItem(id: 't_gb5',      pitchClass: 6,  name: 'Gb', detectedName: 'F#', staffNote: 'Gb5'),
  NoteItem(id: 't_g5',       pitchClass: 7,  name: 'G',  detectedName: 'G',  staffNote: 'G5'),
];

// Bass clef: G2–B3.
// G2 is the bottom (first) staff line; A3 is the top line; B3 is one step above.
const _bassNotes = [
  // ── Octave 2 (G2 = first line, B2 = second line) ─────────────────────────
  NoteItem(id: 'b_g2',       pitchClass: 7,  name: 'G',  detectedName: 'G',  staffNote: 'G2'),
  NoteItem(id: 'b_gsharp2',  pitchClass: 8,  name: 'G#', detectedName: 'G#', staffNote: 'G#2'),
  NoteItem(id: 'b_ab2',      pitchClass: 8,  name: 'Ab', detectedName: 'G#', staffNote: 'Ab2'),
  NoteItem(id: 'b_a2',       pitchClass: 9,  name: 'A',  detectedName: 'A',  staffNote: 'A2'),
  NoteItem(id: 'b_asharp2',  pitchClass: 10, name: 'A#', detectedName: 'A#', staffNote: 'A#2'),
  NoteItem(id: 'b_bb2',      pitchClass: 10, name: 'Bb', detectedName: 'A#', staffNote: 'Bb2'),
  NoteItem(id: 'b_b2',       pitchClass: 11, name: 'B',  detectedName: 'B',  staffNote: 'B2'),
  // ── Octave 3 (C3 = second space, A3 = fifth/top line, B3 = one step above) ─
  NoteItem(id: 'b_c3',       pitchClass: 0,  name: 'C',  detectedName: 'C',  staffNote: 'C3'),
  NoteItem(id: 'b_csharp3',  pitchClass: 1,  name: 'C#', detectedName: 'C#', staffNote: 'C#3'),
  NoteItem(id: 'b_db3',      pitchClass: 1,  name: 'Db', detectedName: 'C#', staffNote: 'Db3'),
  NoteItem(id: 'b_d3',       pitchClass: 2,  name: 'D',  detectedName: 'D',  staffNote: 'D3'),
  NoteItem(id: 'b_dsharp3',  pitchClass: 3,  name: 'D#', detectedName: 'D#', staffNote: 'D#3'),
  NoteItem(id: 'b_eb3',      pitchClass: 3,  name: 'Eb', detectedName: 'D#', staffNote: 'Eb3'),
  NoteItem(id: 'b_e3',       pitchClass: 4,  name: 'E',  detectedName: 'E',  staffNote: 'E3'),
  NoteItem(id: 'b_f3',       pitchClass: 5,  name: 'F',  detectedName: 'F',  staffNote: 'F3'),
  NoteItem(id: 'b_fsharp3',  pitchClass: 6,  name: 'F#', detectedName: 'F#', staffNote: 'F#3'),
  NoteItem(id: 'b_gb3',      pitchClass: 6,  name: 'Gb', detectedName: 'F#', staffNote: 'Gb3'),
  NoteItem(id: 'b_g3',       pitchClass: 7,  name: 'G',  detectedName: 'G',  staffNote: 'G3'),
  NoteItem(id: 'b_gsharp3',  pitchClass: 8,  name: 'G#', detectedName: 'G#', staffNote: 'G#3'),
  NoteItem(id: 'b_ab3',      pitchClass: 8,  name: 'Ab', detectedName: 'G#', staffNote: 'Ab3'),
  NoteItem(id: 'b_a3',       pitchClass: 9,  name: 'A',  detectedName: 'A',  staffNote: 'A3'),
  NoteItem(id: 'b_asharp3',  pitchClass: 10, name: 'A#', detectedName: 'A#', staffNote: 'A#3'),
  NoteItem(id: 'b_bb3',      pitchClass: 10, name: 'Bb', detectedName: 'A#', staffNote: 'Bb3'),
  NoteItem(id: 'b_b3',       pitchClass: 11, name: 'B',  detectedName: 'B',  staffNote: 'B3'),
];

bool _isNatural(NoteItem n) =>
    !n.name.contains('#') && !n.name.contains('b');

List<NoteItem> _forLevel(NoteClef clef, int level) {
  final all = clef == NoteClef.trebleClef ? _trebleNotes : _bassNotes;
  return switch (level) {
    1 => all.where(_isNatural).toList(),
    _ => all.where((n) => !_isNatural(n)).toList(),
  };
}

/// Cumulative pool: includes all notes from levels 1 through [level].
List<NoteItem> buildNotePool(NoteClef clef, int level) {
  final pool = <NoteItem>[];
  for (var i = 1; i <= level.clamp(1, 2); i++) {
    pool.addAll(_forLevel(clef, i));
  }
  return List.unmodifiable(pool);
}

/// Single-level pool: includes only notes belonging to exactly [level].
List<NoteItem> buildNotePoolSingle(NoteClef clef, int level) =>
    List.unmodifiable(_forLevel(clef, level.clamp(1, 2)));
