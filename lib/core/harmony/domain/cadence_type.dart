/// The four cadences, as the degrees they run over.
///
/// Every cadence opens on the tonic. Two chords alone do not say what key they
/// are in, and without a key a cadence is only an interval between two roots.
///
/// The degrees hold for major and for harmonic minor alike, which is why the
/// minor side of this trainer uses harmonic minor: it is the scale that gives
/// the major `V` a cadence needs.
enum CadenceType {
  /// V - I, the one that sounds finished.
  authentic([1, 5, 1]),

  /// IV - I, the amen cadence.
  plagal([1, 4, 1]),

  /// Ends on V rather than resolving to it, so it sounds like a question.
  half([1, 4, 5]),

  /// V - vi, the resolution that goes somewhere else.
  deceptive([1, 5, 6]);

  const CadenceType(this.degrees);

  final List<int> degrees;
}
