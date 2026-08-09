import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../trainer/data/providers.dart';
import '../domain/note_clef.dart';

class SelectedNoteClefNotifier extends Notifier<NoteClef> {
  @override
  NoteClef build() {
    final index = ref.read(settingsRepositoryProvider).loadNoteClef();
    return NoteClef.values[index.clamp(0, NoteClef.values.length - 1)];
  }

  void update(NoteClef clef) => state = clef;
}

final selectedNoteClefProvider =
    NotifierProvider<SelectedNoteClefNotifier, NoteClef>(
        SelectedNoteClefNotifier.new);

class SelectedNoteIntervalNotifier extends Notifier<int> {
  @override
  int build() => ref.read(settingsRepositoryProvider).loadNoteInterval();

  void update(int interval) => state = interval;
}

final selectedNoteIntervalProvider =
    NotifierProvider<SelectedNoteIntervalNotifier, int>(
        SelectedNoteIntervalNotifier.new);

class SelectedNoteLevelNotifier extends Notifier<int> {
  @override
  int build() => ref.read(settingsRepositoryProvider).loadNoteLevel();

  void update(int level) => state = level;
}

final selectedNoteLevelProvider =
    NotifierProvider<SelectedNoteLevelNotifier, int>(
        SelectedNoteLevelNotifier.new);

class SelectedNoteCumulativeNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadNoteCumulative();

  void update(bool v) => state = v;
}

final selectedNoteCumulativeProvider =
    NotifierProvider<SelectedNoteCumulativeNotifier, bool>(
        SelectedNoteCumulativeNotifier.new);
