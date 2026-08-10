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
  static const _keyScaleLevel = 'pref_scale_level';
  static const _keyScaleCumulative = 'pref_scale_cumulative';
  static const _keyScaleDirection = 'pref_scale_direction';
  static const _keyScaleNaturalRoots = 'pref_scale_natural_roots';
  static const _keyScaleInterval = 'pref_scale_interval';
  static const _keyScaleShowNotes = 'pref_scale_show_notes';
  static const _keyArpLevel = 'pref_arp_level';
  static const _keyArpCumulative = 'pref_arp_cumulative';
  static const _keyArpDirection = 'pref_arp_direction';
  static const _keyArpNaturalRoots = 'pref_arp_natural_roots';
  static const _keyArpInterval = 'pref_arp_interval';
  static const _keyArpShowNotes = 'pref_arp_show_notes';
  static const _keyArpInversion = 'pref_arp_inversion';
  static const _keyArpOctaves = 'pref_arp_octaves';

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

  int loadScaleLevel() => _prefs.getInt(_keyScaleLevel) ?? 1;
  bool loadScaleCumulative() => _prefs.getBool(_keyScaleCumulative) ?? true;
  int loadScaleDirection() => _prefs.getInt(_keyScaleDirection) ?? 0;
  bool loadScaleNaturalRoots() => _prefs.getBool(_keyScaleNaturalRoots) ?? true;
  int loadScaleInterval() => _prefs.getInt(_keyScaleInterval) ?? 0;
  bool loadScaleShowNotes() => _prefs.getBool(_keyScaleShowNotes) ?? false;

  Future<void> saveScaleLevel(int level) => _prefs.setInt(_keyScaleLevel, level);
  Future<void> saveScaleCumulative(bool v) => _prefs.setBool(_keyScaleCumulative, v);
  Future<void> saveScaleDirection(int index) => _prefs.setInt(_keyScaleDirection, index);
  Future<void> saveScaleNaturalRoots(bool v) => _prefs.setBool(_keyScaleNaturalRoots, v);
  Future<void> saveScaleInterval(int interval) => _prefs.setInt(_keyScaleInterval, interval);
  Future<void> saveScaleShowNotes(bool v) => _prefs.setBool(_keyScaleShowNotes, v);

  int loadArpLevel() => _prefs.getInt(_keyArpLevel) ?? 1;
  bool loadArpCumulative() => _prefs.getBool(_keyArpCumulative) ?? true;
  int loadArpDirection() => _prefs.getInt(_keyArpDirection) ?? 0;
  bool loadArpNaturalRoots() => _prefs.getBool(_keyArpNaturalRoots) ?? true;
  int loadArpInterval() => _prefs.getInt(_keyArpInterval) ?? 0;
  bool loadArpShowNotes() => _prefs.getBool(_keyArpShowNotes) ?? false;
  int loadArpInversion() => _prefs.getInt(_keyArpInversion) ?? 0;
  int loadArpOctaves() => _prefs.getInt(_keyArpOctaves) ?? 1;

  Future<void> saveArpLevel(int level) => _prefs.setInt(_keyArpLevel, level);
  Future<void> saveArpCumulative(bool v) => _prefs.setBool(_keyArpCumulative, v);
  Future<void> saveArpDirection(int index) => _prefs.setInt(_keyArpDirection, index);
  Future<void> saveArpNaturalRoots(bool v) => _prefs.setBool(_keyArpNaturalRoots, v);
  Future<void> saveArpInterval(int interval) => _prefs.setInt(_keyArpInterval, interval);
  Future<void> saveArpShowNotes(bool v) => _prefs.setBool(_keyArpShowNotes, v);
  Future<void> saveArpInversion(int index) => _prefs.setInt(_keyArpInversion, index);
  Future<void> saveArpOctaves(int octaves) => _prefs.setInt(_keyArpOctaves, octaves);
}
