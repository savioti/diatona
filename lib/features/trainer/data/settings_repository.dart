import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _keyLevel = 'pref_level';
  static const _keyInterval = 'pref_interval';
  static const _keyCumulative = 'pref_cumulative';
  static const _keyThemeIndex = 'pref_theme_index';
  static const _keyDisplayMode = 'pref_display_mode';
  static const _keyLocale = 'pref_locale';
  static const _keyNoteClef = 'pref_note_clef';
  static const _keyNoteInterval = 'pref_note_interval';
  static const _keyNoteLevel = 'pref_note_level';
  static const _keyNoteCumulative = 'pref_note_cumulative';
  static const _keyEarLevel = 'pref_ear_level';
  static const _keyEarDirection = 'pref_ear_direction';
  static const _keyEarCustomMode = 'pref_ear_custom_mode';
  static const _keyEarCustomPool = 'pref_ear_custom_pool';

  int loadLevel() => _prefs.getInt(_keyLevel) ?? 1;
  int loadInterval() => _prefs.getInt(_keyInterval) ?? 5;
  bool loadCumulative() => _prefs.getBool(_keyCumulative) ?? true;
  int loadThemeIndex() => _prefs.getInt(_keyThemeIndex) ?? 0;
  int loadDisplayMode() => _prefs.getInt(_keyDisplayMode) ?? 0;
  String loadLocale() => _prefs.getString(_keyLocale) ?? '';
  int loadNoteClef() => _prefs.getInt(_keyNoteClef) ?? 0;
  int loadNoteInterval() => _prefs.getInt(_keyNoteInterval) ?? 5;
  int loadNoteLevel() => _prefs.getInt(_keyNoteLevel) ?? 1;
  bool loadNoteCumulative() => _prefs.getBool(_keyNoteCumulative) ?? true;

  Future<void> saveLevel(int level) => _prefs.setInt(_keyLevel, level);
  Future<void> saveInterval(int interval) => _prefs.setInt(_keyInterval, interval);
  Future<void> saveCumulative(bool cumulative) => _prefs.setBool(_keyCumulative, cumulative);
  Future<void> saveThemeIndex(int index) => _prefs.setInt(_keyThemeIndex, index);
  Future<void> saveDisplayMode(int index) => _prefs.setInt(_keyDisplayMode, index);
  Future<void> saveLocale(String tag) => _prefs.setString(_keyLocale, tag);
  Future<void> saveNoteClef(int index) => _prefs.setInt(_keyNoteClef, index);
  Future<void> saveNoteInterval(int interval) => _prefs.setInt(_keyNoteInterval, interval);
  Future<void> saveNoteLevel(int level) => _prefs.setInt(_keyNoteLevel, level);
  Future<void> saveNoteCumulative(bool v) => _prefs.setBool(_keyNoteCumulative, v);

  int loadEarLevel() => _prefs.getInt(_keyEarLevel) ?? 1;
  int loadEarDirection() => _prefs.getInt(_keyEarDirection) ?? 0;
  bool loadEarCustomMode() => _prefs.getBool(_keyEarCustomMode) ?? false;
  List<int> loadEarCustomPool() =>
      (_prefs.getString(_keyEarCustomPool) ?? '')
          .split(',')
          .where((s) => s.isNotEmpty)
          .map(int.tryParse)
          .whereType<int>()
          .toList();

  Future<void> saveEarLevel(int level) => _prefs.setInt(_keyEarLevel, level);
  Future<void> saveEarDirection(int index) => _prefs.setInt(_keyEarDirection, index);
  Future<void> saveEarCustomMode(bool v) => _prefs.setBool(_keyEarCustomMode, v);
  Future<void> saveEarCustomPool(List<int> indices) =>
      _prefs.setString(_keyEarCustomPool, indices.join(','));
}
