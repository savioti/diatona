import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/sequence_trainer/domain/sequence_direction.dart';
import '../../ear_trainer/domain/interval_type.dart';
import '../../trainer/data/providers.dart';
import 'interval_pool.dart';

class SelectedIntLevelNotifier extends Notifier<int> {
  @override
  int build() => ref.read(settingsRepositoryProvider).loadIntLevel();

  void update(int level) => state = level;
}

final selectedIntLevelProvider =
    NotifierProvider<SelectedIntLevelNotifier, int>(
        SelectedIntLevelNotifier.new);

class SelectedIntCustomModeNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadIntCustomMode();

  void update(bool v) => state = v;
}

final selectedIntCustomModeProvider =
    NotifierProvider<SelectedIntCustomModeNotifier, bool>(
        SelectedIntCustomModeNotifier.new);

class SelectedIntCustomPoolNotifier extends Notifier<Set<IntervalType>> {
  @override
  Set<IntervalType> build() {
    final saved = ref
        .read(settingsRepositoryProvider)
        .loadIntCustomPool()
        .where((i) => i >= 0 && i < IntervalType.values.length)
        .map((i) => IntervalType.values[i])
        .where(playableIntervals.contains)
        .toSet();
    return saved.isEmpty ? {IntervalType.perfectFifth} : saved;
  }

  void update(Set<IntervalType> pool) => state = pool;
}

final selectedIntCustomPoolProvider =
    NotifierProvider<SelectedIntCustomPoolNotifier, Set<IntervalType>>(
        SelectedIntCustomPoolNotifier.new);

class SelectedIntDirectionNotifier extends Notifier<SequenceDirection> {
  @override
  SequenceDirection build() {
    final index = ref.read(settingsRepositoryProvider).loadIntDirection();
    return SequenceDirection
        .values[index.clamp(0, SequenceDirection.values.length - 1)];
  }

  void update(SequenceDirection direction) => state = direction;
}

final selectedIntDirectionProvider =
    NotifierProvider<SelectedIntDirectionNotifier, SequenceDirection>(
        SelectedIntDirectionNotifier.new);

class SelectedIntNaturalRootsNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadIntNaturalRoots();

  void update(bool v) => state = v;
}

final selectedIntNaturalRootsProvider =
    NotifierProvider<SelectedIntNaturalRootsNotifier, bool>(
        SelectedIntNaturalRootsNotifier.new);

class SelectedIntIntervalNotifier extends Notifier<int> {
  @override
  int build() => ref.read(settingsRepositoryProvider).loadIntInterval();

  void update(int interval) => state = interval;
}

final selectedIntIntervalProvider =
    NotifierProvider<SelectedIntIntervalNotifier, int>(
        SelectedIntIntervalNotifier.new);

class SelectedIntShowNotesNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadIntShowNotes();

  void update(bool v) => state = v;
}

final selectedIntShowNotesProvider =
    NotifierProvider<SelectedIntShowNotesNotifier, bool>(
        SelectedIntShowNotesNotifier.new);

class SelectedIntPlayRootNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadIntPlayRoot();

  void update(bool v) => state = v;
}

final selectedIntPlayRootProvider =
    NotifierProvider<SelectedIntPlayRootNotifier, bool>(
        SelectedIntPlayRootNotifier.new);
