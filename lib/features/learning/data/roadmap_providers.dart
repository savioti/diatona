import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../trainer/data/providers.dart';
import '../domain/roadmap_models.dart';
import 'roadmap_repository.dart';

final roadmapRepositoryProvider = Provider<RoadmapRepository>((ref) {
  return RoadmapRepository(ref.watch(sharedPreferencesProvider));
});

// Holds the currently loaded Roadmap (null = none loaded yet).
class RoadmapNotifier extends AsyncNotifier<Roadmap?> {
  @override
  Future<Roadmap?> build() async {
    final repo = ref.read(roadmapRepositoryProvider);
    final filename = repo.selectedFilename;
    if (filename == null) return null;
    return repo.loadRoadmap(filename);
  }

  Future<void> select(String id, String filename) async {
    state = const AsyncLoading();
    final repo = ref.read(roadmapRepositoryProvider);
    await repo.saveSelection(id, filename);
    state = await AsyncValue.guard(() => repo.loadRoadmap(filename));
  }

  Future<void> clearSelection() async {
    final repo = ref.read(roadmapRepositoryProvider);
    await repo.clearSelection();
    state = const AsyncData(null);
  }
}

final roadmapProvider =
    AsyncNotifierProvider<RoadmapNotifier, Roadmap?>(RoadmapNotifier.new);

// Per-roadmap progress: set of completed topic IDs.
class RoadmapProgressNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final repo = ref.read(roadmapRepositoryProvider);
    final id = repo.selectedId;
    if (id == null) return {};
    return repo.loadProgress(id).toSet();
  }

  Future<void> toggle(String topicId) async {
    final repo = ref.read(roadmapRepositoryProvider);
    final id = repo.selectedId;
    if (id == null) return;

    final next = Set<String>.from(state);
    if (next.contains(topicId)) {
      next.remove(topicId);
    } else {
      next.add(topicId);
    }
    state = next;
    await repo.saveProgress(id, next.toList());
  }

  void reload(String roadmapId) {
    final repo = ref.read(roadmapRepositoryProvider);
    state = repo.loadProgress(roadmapId).toSet();
  }
}

final roadmapProgressProvider =
    NotifierProvider<RoadmapProgressNotifier, Set<String>>(
        RoadmapProgressNotifier.new);
