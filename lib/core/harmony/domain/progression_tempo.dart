/// How long each chord of a progression is held.
///
/// A progression heard slowly is a set of chords, heard quickly it is a phrase.
/// Both are worth hearing, so the speed is a setting rather than a constant.
enum ProgressionTempo {
  slow(1300),
  medium(950),
  fast(650);

  const ProgressionTempo(this.millis);

  final int millis;
}
