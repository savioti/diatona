import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/chord_display_mode.dart';
import 'settings_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('override in main()'),
);

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(sharedPreferencesProvider));
});

class SelectedLevelNotifier extends Notifier<int> {
  @override
  int build() => ref.read(settingsRepositoryProvider).loadLevel();

  void update(int level) => state = level;
}

class SelectedIntervalNotifier extends Notifier<int> {
  @override
  int build() => ref.read(settingsRepositoryProvider).loadInterval();

  void update(int interval) => state = interval;
}

class SelectedCumulativeNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(settingsRepositoryProvider).loadCumulative();

  void update(bool cumulative) => state = cumulative;
}

final selectedLevelProvider =
    NotifierProvider<SelectedLevelNotifier, int>(SelectedLevelNotifier.new);

final selectedIntervalProvider =
    NotifierProvider<SelectedIntervalNotifier, int>(SelectedIntervalNotifier.new);

final selectedCumulativeProvider =
    NotifierProvider<SelectedCumulativeNotifier, bool>(SelectedCumulativeNotifier.new);

class SelectedThemeNotifier extends Notifier<AppThemeVariant> {
  @override
  AppThemeVariant build() {
    final index = ref.read(settingsRepositoryProvider).loadThemeIndex();
    return AppThemeVariant.values[index.clamp(0, AppThemeVariant.values.length - 1)];
  }

  void update(AppThemeVariant variant) => state = variant;
}

final selectedThemeProvider =
    NotifierProvider<SelectedThemeNotifier, AppThemeVariant>(SelectedThemeNotifier.new);

class SelectedDisplayModeNotifier extends Notifier<ChordDisplayMode> {
  @override
  ChordDisplayMode build() {
    final index = ref.read(settingsRepositoryProvider).loadDisplayMode();
    return ChordDisplayMode.values[index.clamp(0, ChordDisplayMode.values.length - 1)];
  }

  void update(ChordDisplayMode mode) => state = mode;
}

final selectedDisplayModeProvider =
    NotifierProvider<SelectedDisplayModeNotifier, ChordDisplayMode>(
        SelectedDisplayModeNotifier.new);
