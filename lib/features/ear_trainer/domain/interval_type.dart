enum IntervalType {
  minSecond,
  majSecond,
  minThird,
  majThird,
  perfectFourth,
  tritone,
  perfectFifth,
  minSixth,
  majSixth,
  minSeventh,
  majSeventh,
  octave;

  int get semitones => switch (this) {
        IntervalType.minSecond => 1,
        IntervalType.majSecond => 2,
        IntervalType.minThird => 3,
        IntervalType.majThird => 4,
        IntervalType.perfectFourth => 5,
        IntervalType.tritone => 6,
        IntervalType.perfectFifth => 7,
        IntervalType.minSixth => 8,
        IntervalType.majSixth => 9,
        IntervalType.minSeventh => 10,
        IntervalType.majSeventh => 11,
        IntervalType.octave => 12,
      };

  /// How many letter names the interval spans, so 2 for any third and 4 for a
  /// fifth. It is what tells a minor third from an augmented second, and it
  /// spells the tritone as an augmented fourth: C to F#, Db to G.
  int get letterStep => switch (this) {
        IntervalType.minSecond || IntervalType.majSecond => 1,
        IntervalType.minThird || IntervalType.majThird => 2,
        IntervalType.perfectFourth || IntervalType.tritone => 3,
        IntervalType.perfectFifth => 4,
        IntervalType.minSixth || IntervalType.majSixth => 5,
        IntervalType.minSeventh || IntervalType.majSeventh => 6,
        IntervalType.octave => 7,
      };

  /// Short label used on answer buttons (e.g. "m2", "P5").
  String get shortLabel => switch (this) {
        IntervalType.minSecond => 'm2',
        IntervalType.majSecond => 'M2',
        IntervalType.minThird => 'm3',
        IntervalType.majThird => 'M3',
        IntervalType.perfectFourth => 'P4',
        IntervalType.tritone => 'TT',
        IntervalType.perfectFifth => 'P5',
        IntervalType.minSixth => 'm6',
        IntervalType.majSixth => 'M6',
        IntervalType.minSeventh => 'm7',
        IntervalType.majSeventh => 'M7',
        IntervalType.octave => 'P8',
      };
}
