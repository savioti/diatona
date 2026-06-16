import '../domain/interval_type.dart';

/// Progressive interval pools for levels 1–6.
///
/// Level 1 uses the most acoustically distinct pair; each level adds
/// intervals that sit closer together perceptually until all 12 are present.
const _levelIntervals = <List<IntervalType>>[
  // 1 — wide & unmistakeable
  [IntervalType.perfectFifth, IntervalType.octave],
  // 2 — add the major third
  [IntervalType.majThird, IntervalType.perfectFifth, IntervalType.octave],
  // 3 — swap octave for perfect fourth (more similar challenge)
  [IntervalType.majThird, IntervalType.perfectFourth, IntervalType.perfectFifth],
  // 4 — add minor third
  [
    IntervalType.minThird,
    IntervalType.majThird,
    IntervalType.perfectFourth,
    IntervalType.perfectFifth,
  ],
  // 5 — add major second and minor seventh
  [
    IntervalType.majSecond,
    IntervalType.minThird,
    IntervalType.majThird,
    IntervalType.perfectFourth,
    IntervalType.perfectFifth,
    IntervalType.minSeventh,
  ],
  // 6 — all twelve
  IntervalType.values,
];

const int kEarTrainerLevelCount = 6;

List<IntervalType> getIntervalsForLevel(int level) {
  assert(level >= 1 && level <= kEarTrainerLevelCount);
  return _levelIntervals[level - 1];
}
