import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/harmony/data/progression_data.dart';
import '../../../core/harmony/domain/progression_tempo.dart';
import '../../trainer/data/providers.dart';

/// Which progressions the ear rounds are drawn from, by id.
///
/// Two at least: one progression on its own is not a question.
class SelectedPearPoolNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final saved = ref
        .read(settingsRepositoryProvider)
        .loadPearPool()
        .where((id) => progressionById(id) != null)
        .toSet();
    return saved.length >= 2 ? saved : _defaultPool();
  }

  Set<String> _defaultPool() =>
      progressionData.take(3).map((p) => p.id).toSet();

  void update(Set<String> pool) => state = pool;
}

final selectedPearPoolProvider =
    NotifierProvider<SelectedPearPoolNotifier, Set<String>>(
        SelectedPearPoolNotifier.new);

class SelectedPearTempoNotifier extends Notifier<ProgressionTempo> {
  @override
  ProgressionTempo build() {
    final index = ref.read(settingsRepositoryProvider).loadPearTempo();
    return ProgressionTempo
        .values[index.clamp(0, ProgressionTempo.values.length - 1)];
  }

  void update(ProgressionTempo tempo) => state = tempo;
}

final selectedPearTempoProvider =
    NotifierProvider<SelectedPearTempoNotifier, ProgressionTempo>(
        SelectedPearTempoNotifier.new);

class SelectedPearArpeggiateNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadPearArpeggiate();

  void update(bool v) => state = v;
}

final selectedPearArpeggiateProvider =
    NotifierProvider<SelectedPearArpeggiateNotifier, bool>(
        SelectedPearArpeggiateNotifier.new);

class SelectedPearNaturalRootsNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadPearNaturalRoots();

  void update(bool v) => state = v;
}

final selectedPearNaturalRootsProvider =
    NotifierProvider<SelectedPearNaturalRootsNotifier, bool>(
        SelectedPearNaturalRootsNotifier.new);
