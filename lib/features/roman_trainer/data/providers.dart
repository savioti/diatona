import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../scale_trainer/domain/scale_type.dart';
import '../../trainer/data/providers.dart';
import '../domain/roman_question.dart';

class SelectedRnScalesNotifier extends Notifier<Set<ScaleType>> {
  @override
  Set<ScaleType> build() {
    final saved = ref
        .read(settingsRepositoryProvider)
        .loadRnScales()
        .where((i) => i >= 0 && i < ScaleType.values.length)
        .map((i) => ScaleType.values[i])
        .toSet();
    return saved.isEmpty ? {ScaleType.major} : saved;
  }

  void update(Set<ScaleType> scales) => state = scales;
}

final selectedRnScalesProvider =
    NotifierProvider<SelectedRnScalesNotifier, Set<ScaleType>>(
        SelectedRnScalesNotifier.new);

class SelectedRnModeNotifier extends Notifier<RomanDrillMode> {
  @override
  RomanDrillMode build() {
    final index = ref.read(settingsRepositoryProvider).loadRnMode();
    return RomanDrillMode
        .values[index.clamp(0, RomanDrillMode.values.length - 1)];
  }

  void update(RomanDrillMode mode) => state = mode;
}

final selectedRnModeProvider =
    NotifierProvider<SelectedRnModeNotifier, RomanDrillMode>(
        SelectedRnModeNotifier.new);

class SelectedRnSeventhsNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadRnSevenths();

  void update(bool v) => state = v;
}

final selectedRnSeventhsProvider =
    NotifierProvider<SelectedRnSeventhsNotifier, bool>(
        SelectedRnSeventhsNotifier.new);

class SelectedRnNaturalRootsNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadRnNaturalRoots();

  void update(bool v) => state = v;
}

final selectedRnNaturalRootsProvider =
    NotifierProvider<SelectedRnNaturalRootsNotifier, bool>(
        SelectedRnNaturalRootsNotifier.new);

class SelectedRnHearChordNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadRnHearChord();

  void update(bool v) => state = v;
}

final selectedRnHearChordProvider =
    NotifierProvider<SelectedRnHearChordNotifier, bool>(
        SelectedRnHearChordNotifier.new);
