import 'package:flutter/foundation.dart';

import '../../../features/scale_trainer/domain/scale_type.dart';

/// A tonic and the scale built on it, which is all a degree needs to become a
/// chord. [root] is already spelled, `Eb` rather than `D#`.
@immutable
class HarmonicKey {
  const HarmonicKey(this.root, this.scale);

  final String root;
  final ScaleType scale;

  String get id => '${root}_${scale.name}';

  @override
  bool operator ==(Object other) =>
      other is HarmonicKey && other.root == root && other.scale == scale;

  @override
  int get hashCode => Object.hash(root, scale);

  @override
  String toString() => '$root ${scale.name}';
}
