import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/sequence_trainer/domain/sequence_direction.dart';
import '../../trainer/data/providers.dart';
import '../domain/arpeggio_inversion.dart';

class SelectedArpLevelNotifier extends Notifier<int> {
  @override
  int build() => ref.read(settingsRepositoryProvider).loadArpLevel();

  void update(int level) => state = level;
}

final selectedArpLevelProvider =
    NotifierProvider<SelectedArpLevelNotifier, int>(
        SelectedArpLevelNotifier.new);

class SelectedArpCumulativeNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadArpCumulative();

  void update(bool v) => state = v;
}

final selectedArpCumulativeProvider =
    NotifierProvider<SelectedArpCumulativeNotifier, bool>(
        SelectedArpCumulativeNotifier.new);

class SelectedArpDirectionNotifier extends Notifier<SequenceDirection> {
  @override
  SequenceDirection build() {
    final index = ref.read(settingsRepositoryProvider).loadArpDirection();
    return SequenceDirection
        .values[index.clamp(0, SequenceDirection.values.length - 1)];
  }

  void update(SequenceDirection direction) => state = direction;
}

final selectedArpDirectionProvider =
    NotifierProvider<SelectedArpDirectionNotifier, SequenceDirection>(
        SelectedArpDirectionNotifier.new);

class SelectedArpNaturalRootsNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadArpNaturalRoots();

  void update(bool v) => state = v;
}

final selectedArpNaturalRootsProvider =
    NotifierProvider<SelectedArpNaturalRootsNotifier, bool>(
        SelectedArpNaturalRootsNotifier.new);

class SelectedArpIntervalNotifier extends Notifier<int> {
  @override
  int build() => ref.read(settingsRepositoryProvider).loadArpInterval();

  void update(int interval) => state = interval;
}

final selectedArpIntervalProvider =
    NotifierProvider<SelectedArpIntervalNotifier, int>(
        SelectedArpIntervalNotifier.new);

class SelectedArpShowNotesNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadArpShowNotes();

  void update(bool v) => state = v;
}

final selectedArpShowNotesProvider =
    NotifierProvider<SelectedArpShowNotesNotifier, bool>(
        SelectedArpShowNotesNotifier.new);

class SelectedArpInversionNotifier extends Notifier<ArpeggioInversion> {
  @override
  ArpeggioInversion build() {
    final index = ref.read(settingsRepositoryProvider).loadArpInversion();
    return ArpeggioInversion
        .values[index.clamp(0, ArpeggioInversion.values.length - 1)];
  }

  void update(ArpeggioInversion inversion) => state = inversion;
}

final selectedArpInversionProvider =
    NotifierProvider<SelectedArpInversionNotifier, ArpeggioInversion>(
        SelectedArpInversionNotifier.new);

class SelectedArpOctavesNotifier extends Notifier<int> {
  @override
  int build() => ref.read(settingsRepositoryProvider).loadArpOctaves();

  void update(int octaves) => state = octaves;
}

final selectedArpOctavesProvider =
    NotifierProvider<SelectedArpOctavesNotifier, int>(
        SelectedArpOctavesNotifier.new);
