/// What a chord does in its key: rest, departure or tension.
///
/// Unlike the roman numeral, this is not derivable from the notes, so it is
/// read from the `function` field of each degree in `scales.json`.
enum HarmonicFunction {
  tonic,
  subdominant,
  dominant;

  static HarmonicFunction fromId(String id) => switch (id) {
        'subdominant' => HarmonicFunction.subdominant,
        'dominant' => HarmonicFunction.dominant,
        _ => HarmonicFunction.tonic,
      };
}
