import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../trainer/data/providers.dart';
import '../domain/interval_direction.dart';
import '../domain/interval_type.dart';

class EarLevelNotifier extends Notifier<int> {
  @override
  int build() => ref.read(settingsRepositoryProvider).loadEarLevel();

  void update(int level) => state = level;
}

final earLevelProvider =
    NotifierProvider<EarLevelNotifier, int>(EarLevelNotifier.new);

class EarDirectionNotifier extends Notifier<IntervalDirection> {
  @override
  IntervalDirection build() {
    final idx = ref.read(settingsRepositoryProvider).loadEarDirection();
    return IntervalDirection.values[idx.clamp(0, IntervalDirection.values.length - 1)];
  }

  void update(IntervalDirection d) => state = d;
}

final earDirectionProvider =
    NotifierProvider<EarDirectionNotifier, IntervalDirection>(EarDirectionNotifier.new);

class EarCustomModeNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadEarCustomMode();

  void update(bool v) => state = v;
}

final earCustomModeProvider =
    NotifierProvider<EarCustomModeNotifier, bool>(EarCustomModeNotifier.new);

class EarCustomPoolNotifier extends Notifier<Set<IntervalType>> {
  @override
  Set<IntervalType> build() {
    final indices = ref.read(settingsRepositoryProvider).loadEarCustomPool();
    if (indices.isEmpty) {
      // Default custom pool: all intervals
      return IntervalType.values.toSet();
    }
    return indices
        .where((i) => i >= 0 && i < IntervalType.values.length)
        .map((i) => IntervalType.values[i])
        .toSet();
  }

  void update(Set<IntervalType> pool) => state = pool;
}

final earCustomPoolProvider =
    NotifierProvider<EarCustomPoolNotifier, Set<IntervalType>>(EarCustomPoolNotifier.new);
