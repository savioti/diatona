import 'chord_type.dart';

class Chord {
  const Chord({
    required this.symbol,
    required this.type,
    this.altSymbol,
    this.soundAssetPath,
    this.diagramAssetPath,
  });

  final String symbol;

  /// Enharmonic equivalent full symbol, e.g. "Dbm7b5" when symbol is "C#m7b5".
  final String? altSymbol;
  final ChordType type;
  final String? soundAssetPath;
  final String? diagramAssetPath;

  String get rootNote {
    final match = RegExp(r'^([A-G][b#]?)').firstMatch(symbol);
    return match?.group(1) ?? symbol[0];
  }

  String? get altRootNote {
    if (altSymbol == null) return null;
    final match = RegExp(r'^([A-G][b#]?)').firstMatch(altSymbol!);
    return match?.group(1);
  }

  @override
  bool operator ==(Object other) =>
      other is Chord && other.symbol == symbol && other.type == type;

  @override
  int get hashCode => Object.hash(symbol, type);
}
