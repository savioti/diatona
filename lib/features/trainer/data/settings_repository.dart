import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _keyLevel = 'pref_level';
  static const _keyInterval = 'pref_interval';
  static const _keyCumulative = 'pref_cumulative';
  static const _keyThemeIndex = 'pref_theme_index';
  static const _keyDisplayMode = 'pref_display_mode';
  static const _keyNoteClef = 'pref_note_clef';
  static const _keyNoteInterval = 'pref_note_interval';
  static const _keyNoteLevel = 'pref_note_level';
  static const _keyNoteCumulative = 'pref_note_cumulative';

  int loadLevel() => _prefs.getInt(_keyLevel) ?? 1;
  int loadInterval() => _prefs.getInt(_keyInterval) ?? 5;
  bool loadCumulative() => _prefs.getBool(_keyCumulative) ?? true;
  int loadThemeIndex() => _prefs.getInt(_keyThemeIndex) ?? 0;
  int loadDisplayMode() => _prefs.getInt(_keyDisplayMode) ?? 0;
  int loadNoteClef() => _prefs.getInt(_keyNoteClef) ?? 0;
  int loadNoteInterval() => _prefs.getInt(_keyNoteInterval) ?? 5;
  int loadNoteLevel() => _prefs.getInt(_keyNoteLevel) ?? 1;
  bool loadNoteCumulative() => _prefs.getBool(_keyNoteCumulative) ?? true;

  Future<void> saveLevel(int level) => _prefs.setInt(_keyLevel, level);
  Future<void> saveInterval(int interval) => _prefs.setInt(_keyInterval, interval);
  Future<void> saveCumulative(bool cumulative) => _prefs.setBool(_keyCumulative, cumulative);
  Future<void> saveThemeIndex(int index) => _prefs.setInt(_keyThemeIndex, index);
  Future<void> saveDisplayMode(int index) => _prefs.setInt(_keyDisplayMode, index);
  Future<void> saveNoteClef(int index) => _prefs.setInt(_keyNoteClef, index);
  Future<void> saveNoteInterval(int interval) => _prefs.setInt(_keyNoteInterval, interval);
  Future<void> saveNoteLevel(int level) => _prefs.setInt(_keyNoteLevel, level);
  Future<void> saveNoteCumulative(bool v) => _prefs.setBool(_keyNoteCumulative, v);
}
