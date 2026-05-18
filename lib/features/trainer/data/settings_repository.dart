import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _keyLevel = 'pref_level';
  static const _keyInterval = 'pref_interval';
  static const _keyCumulative = 'pref_cumulative';
  static const _keyThemeIndex = 'pref_theme_index';

  int loadLevel() => _prefs.getInt(_keyLevel) ?? 1;
  int loadInterval() => _prefs.getInt(_keyInterval) ?? 5;
  bool loadCumulative() => _prefs.getBool(_keyCumulative) ?? true;
  int loadThemeIndex() => _prefs.getInt(_keyThemeIndex) ?? 0;

  Future<void> saveLevel(int level) => _prefs.setInt(_keyLevel, level);
  Future<void> saveInterval(int interval) => _prefs.setInt(_keyInterval, interval);
  Future<void> saveCumulative(bool cumulative) => _prefs.setBool(_keyCumulative, cumulative);
  Future<void> saveThemeIndex(int index) => _prefs.setInt(_keyThemeIndex, index);
}
