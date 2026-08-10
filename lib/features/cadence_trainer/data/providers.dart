import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/harmony/domain/cadence_type.dart';
import '../../../core/harmony/domain/progression_tempo.dart';
import '../../trainer/data/providers.dart';

class SelectedCadPoolNotifier extends Notifier<Set<CadenceType>> {
  @override
  Set<CadenceType> build() {
    final saved = ref
        .read(settingsRepositoryProvider)
        .loadCadPool()
        .where((i) => i >= 0 && i < CadenceType.values.length)
        .map((i) => CadenceType.values[i])
        .toSet();
    return saved.length >= 2 ? saved : CadenceType.values.toSet();
  }

  void update(Set<CadenceType> pool) => state = pool;
}

final selectedCadPoolProvider =
    NotifierProvider<SelectedCadPoolNotifier, Set<CadenceType>>(
        SelectedCadPoolNotifier.new);

class SelectedCadMinorNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadCadMinor();

  void update(bool v) => state = v;
}

final selectedCadMinorProvider =
    NotifierProvider<SelectedCadMinorNotifier, bool>(
        SelectedCadMinorNotifier.new);

class SelectedCadTempoNotifier extends Notifier<ProgressionTempo> {
  @override
  ProgressionTempo build() {
    final index = ref.read(settingsRepositoryProvider).loadCadTempo();
    return ProgressionTempo
        .values[index.clamp(0, ProgressionTempo.values.length - 1)];
  }

  void update(ProgressionTempo tempo) => state = tempo;
}

final selectedCadTempoProvider =
    NotifierProvider<SelectedCadTempoNotifier, ProgressionTempo>(
        SelectedCadTempoNotifier.new);

class SelectedCadNaturalRootsNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadCadNaturalRoots();

  void update(bool v) => state = v;
}

final selectedCadNaturalRootsProvider =
    NotifierProvider<SelectedCadNaturalRootsNotifier, bool>(
        SelectedCadNaturalRootsNotifier.new);
