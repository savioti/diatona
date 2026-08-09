import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/music_reference.dart';

Future<List<MusicReference>> loadMusicReferences() async {
  final raw =
      await rootBundle.loadString('database/references/music_references.json');
  final data = jsonDecode(raw) as Map<String, dynamic>;
  final list =
      (data['references'] as List<dynamic>).cast<Map<String, dynamic>>();
  return list.map(MusicReference.fromJson).toList();
}
