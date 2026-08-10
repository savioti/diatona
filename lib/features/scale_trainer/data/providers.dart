import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/sequence_trainer/domain/sequence_direction.dart';
import '../../trainer/data/providers.dart';

class SelectedScaleLevelNotifier extends Notifier<int> {
  @override
  int build() => ref.read(settingsRepositoryProvider).loadScaleLevel();

  void update(int level) => state = level;
}

final selectedScaleLevelProvider =
    NotifierProvider<SelectedScaleLevelNotifier, int>(
        SelectedScaleLevelNotifier.new);

class SelectedScaleCumulativeNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadScaleCumulative();

  void update(bool v) => state = v;
}

final selectedScaleCumulativeProvider =
    NotifierProvider<SelectedScaleCumulativeNotifier, bool>(
        SelectedScaleCumulativeNotifier.new);

class SelectedScaleDirectionNotifier extends Notifier<SequenceDirection> {
  @override
  SequenceDirection build() {
    final index = ref.read(settingsRepositoryProvider).loadScaleDirection();
    return SequenceDirection
        .values[index.clamp(0, SequenceDirection.values.length - 1)];
  }

  void update(SequenceDirection direction) => state = direction;
}

final selectedScaleDirectionProvider =
    NotifierProvider<SelectedScaleDirectionNotifier, SequenceDirection>(
        SelectedScaleDirectionNotifier.new);

class SelectedScaleNaturalRootsNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadScaleNaturalRoots();

  void update(bool v) => state = v;
}

final selectedScaleNaturalRootsProvider =
    NotifierProvider<SelectedScaleNaturalRootsNotifier, bool>(
        SelectedScaleNaturalRootsNotifier.new);

class SelectedScaleIntervalNotifier extends Notifier<int> {
  @override
  int build() => ref.read(settingsRepositoryProvider).loadScaleInterval();

  void update(int interval) => state = interval;
}

final selectedScaleIntervalProvider =
    NotifierProvider<SelectedScaleIntervalNotifier, int>(
        SelectedScaleIntervalNotifier.new);

class SelectedScaleShowNotesNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadScaleShowNotes();

  void update(bool v) => state = v;
}

final selectedScaleShowNotesProvider =
    NotifierProvider<SelectedScaleShowNotesNotifier, bool>(
        SelectedScaleShowNotesNotifier.new);
