/// Scale types in trainer level order, from the most common to the rarest.
enum ScaleType {
  major('scale_major'),
  naturalMinor('scale_natural_minor'),
  dorian('scale_dorian'),
  mixolydian('scale_mixolydian'),
  lydian('scale_lydian'),
  phrygian('scale_phrygian'),
  locrian('scale_locrian'),
  harmonicMinor('scale_harmonic_minor'),
  melodicMinor('scale_melodic_minor');

  const ScaleType(this.id);

  /// Matches the `id` field of an entry in `database/trainer/scales.json`.
  final String id;
}
