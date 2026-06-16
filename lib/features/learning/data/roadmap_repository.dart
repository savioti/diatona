import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/roadmap_models.dart';

const _keySelectedId = 'roadmap_selected_id';
const _keySelectedFilename = 'roadmap_selected_filename';

String _progressKey(String roadmapId) => 'roadmap_progress_$roadmapId';

const List<RoadmapOption> kAvailableRoadmaps = [
  RoadmapOption(
    id: 'rm-wmt',
    title: 'Western Music Theory',
    shortDescription: 'Comprehensive foundation in Western music theory.',
    filename: 'western_music_theory_roadmap.json',
    icon: '🎼',
  ),
  RoadmapOption(
    id: 'rm-pno',
    title: 'Piano / Keyboard',
    shortDescription: 'From first notes to advanced piano playing.',
    filename: 'piano_roadmap.json',
    icon: '🎹',
  ),
  RoadmapOption(
    id: 'rm-gtr',
    title: 'Guitar (Violão)',
    shortDescription: 'Acoustic guitar from beginner to advanced.',
    filename: 'acoustic_guitar_roadmap.json',
    icon: '🎸',
  ),
  RoadmapOption(
    id: 'rm-egtr',
    title: 'Electric Guitar',
    shortDescription: 'Electric guitar techniques and styles.',
    filename: 'eletric_guitar_roadmap.json',
    icon: '🎸',
  ),
  RoadmapOption(
    id: 'rm-bass',
    title: 'Electric Bass',
    shortDescription: 'Bass guitar fundamentals to advanced grooves.',
    filename: 'bass_guitar_roadmap.json',
    icon: '🎸',
  ),
  RoadmapOption(
    id: 'rm-drm',
    title: 'Drums',
    shortDescription: 'Drumming from basic beats to advanced patterns.',
    filename: 'drums_roadmap.json',
    icon: '🥁',
  ),
  RoadmapOption(
    id: 'rm-uku',
    title: 'Ukulele',
    shortDescription: 'Ukulele from first chords to performance.',
    filename: 'ukulele_roadmap.json',
    icon: '🎵',
  ),
  RoadmapOption(
    id: 'rm-cla',
    title: 'Clarinet',
    shortDescription: 'Clarinet from embouchure basics to repertoire.',
    filename: 'clarinet_roadmap.json',
    icon: '🎵',
  ),
];

class RoadmapRepository {
  const RoadmapRepository(this._prefs);

  final SharedPreferences _prefs;

  String? get selectedId => _prefs.getString(_keySelectedId);
  String? get selectedFilename => _prefs.getString(_keySelectedFilename);

  Future<void> saveSelection(String id, String filename) async {
    await _prefs.setString(_keySelectedId, id);
    await _prefs.setString(_keySelectedFilename, filename);
  }

  Future<void> clearSelection() async {
    await _prefs.remove(_keySelectedId);
    await _prefs.remove(_keySelectedFilename);
  }

  List<String> loadProgress(String roadmapId) {
    final raw = _prefs.getString(_progressKey(roadmapId));
    if (raw == null) return [];
    return (jsonDecode(raw) as List<dynamic>).cast<String>();
  }

  Future<void> saveProgress(String roadmapId, List<String> completedIds) async {
    await _prefs.setString(_progressKey(roadmapId), jsonEncode(completedIds));
  }

  Future<Roadmap> loadRoadmap(String filename) async {
    final raw = await rootBundle.loadString('database/roadmaps/$filename');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return Roadmap.fromJson(json);
  }
}
