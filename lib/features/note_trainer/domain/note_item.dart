import 'package:flutter/foundation.dart';

@immutable
class NoteItem {
  const NoteItem({
    required this.id,
    required this.pitchClass,
    required this.name,
    required this.detectedName,
    required this.staffNote,
  });

  final String id;
  final int pitchClass;

  /// Display name, e.g. "C#" or "Db".
  final String name;

  /// Sharp-form name the pitch detector always emits (e.g. "C#" for both C# and Db).
  final String detectedName;

  /// Note string passed to StaffNotationWidget, e.g. "Db5", "G#4".
  final String staffNote;

  @override
  bool operator ==(Object other) => other is NoteItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
