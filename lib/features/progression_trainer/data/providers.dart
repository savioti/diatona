import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/harmony/data/progression_data.dart';
import '../../trainer/data/providers.dart';

/// Which progressions the rounds are drawn from, by id.
///
/// Ids rather than indices: `progressions.json` can gain an entry without the
/// saved pool silently becoming a different set of progressions.
class SelectedProgPoolNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final saved = ref
        .read(settingsRepositoryProvider)
        .loadProgPool()
        .where((id) => progressionById(id) != null)
        .toSet();
    return saved.isEmpty ? _defaultPool() : saved;
  }

  Set<String> _defaultPool() {
    final first = progressionData.isEmpty ? null : progressionData.first.id;
    return first == null ? <String>{} : {first};
  }

  void update(Set<String> pool) => state = pool;
}

final selectedProgPoolProvider =
    NotifierProvider<SelectedProgPoolNotifier, Set<String>>(
        SelectedProgPoolNotifier.new);

class SelectedProgNaturalRootsNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadProgNaturalRoots();

  void update(bool v) => state = v;
}

final selectedProgNaturalRootsProvider =
    NotifierProvider<SelectedProgNaturalRootsNotifier, bool>(
        SelectedProgNaturalRootsNotifier.new);

class SelectedProgIntervalNotifier extends Notifier<int> {
  @override
  int build() => ref.read(settingsRepositoryProvider).loadProgInterval();

  void update(int interval) => state = interval;
}

final selectedProgIntervalProvider =
    NotifierProvider<SelectedProgIntervalNotifier, int>(
        SelectedProgIntervalNotifier.new);

class SelectedProgShowNotesNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadProgShowNotes();

  void update(bool v) => state = v;
}

final selectedProgShowNotesProvider =
    NotifierProvider<SelectedProgShowNotesNotifier, bool>(
        SelectedProgShowNotesNotifier.new);

class SelectedProgArpeggiateNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadProgArpeggiate();

  void update(bool v) => state = v;
}

final selectedProgArpeggiateProvider =
    NotifierProvider<SelectedProgArpeggiateNotifier, bool>(
        SelectedProgArpeggiateNotifier.new);
