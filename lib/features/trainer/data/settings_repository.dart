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
  static const _keyIntLevel = 'pref_int_level';
  static const _keyIntCustomMode = 'pref_int_custom_mode';
  static const _keyIntCustomPool = 'pref_int_custom_pool';
  static const _keyIntDirection = 'pref_int_direction';
  static const _keyIntNaturalRoots = 'pref_int_natural_roots';
  static const _keyIntInterval = 'pref_int_interval';
  static const _keyIntShowNotes = 'pref_int_show_notes';
  static const _keyIntPlayRoot = 'pref_int_play_root';
  static const _keyProgPool = 'pref_prog_pool';
  static const _keyProgNaturalRoots = 'pref_prog_natural_roots';
  static const _keyProgInterval = 'pref_prog_interval';
  static const _keyProgShowNotes = 'pref_prog_show_notes';
  static const _keyProgArpeggiate = 'pref_prog_arpeggiate';
  static const _keyRnScales = 'pref_rn_scales';
  static const _keyRnMode = 'pref_rn_mode';
  static const _keyRnSevenths = 'pref_rn_sevenths';
  static const _keyRnNaturalRoots = 'pref_rn_natural_roots';
  static const _keyRnHearChord = 'pref_rn_hear_chord';
  static const _keyPearPool = 'pref_pear_pool';
  static const _keyPearTempo = 'pref_pear_tempo';
  static const _keyPearArpeggiate = 'pref_pear_arpeggiate';
  static const _keyPearNaturalRoots = 'pref_pear_natural_roots';
  static const _keyCadPool = 'pref_cad_pool';
  static const _keyCadMinor = 'pref_cad_minor';
  static const _keyCadTempo = 'pref_cad_tempo';
  static const _keyCadNaturalRoots = 'pref_cad_natural_roots';

  /// Pools are stored as a comma separated list, which is all
  /// [SharedPreferences] takes without a list of its own.
  List<int> _intList(String key) => (_prefs.getString(key) ?? '')
      .split(',')
      .where((s) => s.isNotEmpty)
      .map(int.tryParse)
      .whereType<int>()
      .toList();

  List<String> _stringList(String key) => (_prefs.getString(key) ?? '')
      .split(',')
      .where((s) => s.isNotEmpty)
      .toList();

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
  List<int> loadEarCustomPool() => _intList(_keyEarCustomPool);

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

  int loadIntLevel() => _prefs.getInt(_keyIntLevel) ?? 1;
  bool loadIntCustomMode() => _prefs.getBool(_keyIntCustomMode) ?? false;
  List<int> loadIntCustomPool() => _intList(_keyIntCustomPool);
  int loadIntDirection() => _prefs.getInt(_keyIntDirection) ?? 0;
  bool loadIntNaturalRoots() => _prefs.getBool(_keyIntNaturalRoots) ?? true;
  int loadIntInterval() => _prefs.getInt(_keyIntInterval) ?? 0;
  bool loadIntShowNotes() => _prefs.getBool(_keyIntShowNotes) ?? false;
  bool loadIntPlayRoot() => _prefs.getBool(_keyIntPlayRoot) ?? true;

  Future<void> saveIntLevel(int level) => _prefs.setInt(_keyIntLevel, level);
  Future<void> saveIntCustomMode(bool v) => _prefs.setBool(_keyIntCustomMode, v);
  Future<void> saveIntCustomPool(List<int> indices) =>
      _prefs.setString(_keyIntCustomPool, indices.join(','));
  Future<void> saveIntDirection(int index) => _prefs.setInt(_keyIntDirection, index);
  Future<void> saveIntNaturalRoots(bool v) => _prefs.setBool(_keyIntNaturalRoots, v);
  Future<void> saveIntInterval(int interval) => _prefs.setInt(_keyIntInterval, interval);
  Future<void> saveIntShowNotes(bool v) => _prefs.setBool(_keyIntShowNotes, v);
  Future<void> saveIntPlayRoot(bool v) => _prefs.setBool(_keyIntPlayRoot, v);

  List<String> loadProgPool() => _stringList(_keyProgPool);
  bool loadProgNaturalRoots() => _prefs.getBool(_keyProgNaturalRoots) ?? true;
  int loadProgInterval() => _prefs.getInt(_keyProgInterval) ?? 0;
  bool loadProgShowNotes() => _prefs.getBool(_keyProgShowNotes) ?? false;
  bool loadProgArpeggiate() => _prefs.getBool(_keyProgArpeggiate) ?? false;

  Future<void> saveProgPool(List<String> ids) =>
      _prefs.setString(_keyProgPool, ids.join(','));
  Future<void> saveProgNaturalRoots(bool v) =>
      _prefs.setBool(_keyProgNaturalRoots, v);
  Future<void> saveProgInterval(int interval) =>
      _prefs.setInt(_keyProgInterval, interval);
  Future<void> saveProgShowNotes(bool v) =>
      _prefs.setBool(_keyProgShowNotes, v);
  Future<void> saveProgArpeggiate(bool v) =>
      _prefs.setBool(_keyProgArpeggiate, v);

  List<int> loadRnScales() => _intList(_keyRnScales);
  int loadRnMode() => _prefs.getInt(_keyRnMode) ?? 0;
  bool loadRnSevenths() => _prefs.getBool(_keyRnSevenths) ?? false;
  bool loadRnNaturalRoots() => _prefs.getBool(_keyRnNaturalRoots) ?? true;
  bool loadRnHearChord() => _prefs.getBool(_keyRnHearChord) ?? true;

  Future<void> saveRnScales(List<int> indices) =>
      _prefs.setString(_keyRnScales, indices.join(','));
  Future<void> saveRnMode(int index) => _prefs.setInt(_keyRnMode, index);
  Future<void> saveRnSevenths(bool v) => _prefs.setBool(_keyRnSevenths, v);
  Future<void> saveRnNaturalRoots(bool v) =>
      _prefs.setBool(_keyRnNaturalRoots, v);
  Future<void> saveRnHearChord(bool v) => _prefs.setBool(_keyRnHearChord, v);

  List<String> loadPearPool() => _stringList(_keyPearPool);
  int loadPearTempo() => _prefs.getInt(_keyPearTempo) ?? 1;
  bool loadPearArpeggiate() => _prefs.getBool(_keyPearArpeggiate) ?? false;
  bool loadPearNaturalRoots() => _prefs.getBool(_keyPearNaturalRoots) ?? true;

  Future<void> savePearPool(List<String> ids) =>
      _prefs.setString(_keyPearPool, ids.join(','));
  Future<void> savePearTempo(int index) => _prefs.setInt(_keyPearTempo, index);
  Future<void> savePearArpeggiate(bool v) =>
      _prefs.setBool(_keyPearArpeggiate, v);
  Future<void> savePearNaturalRoots(bool v) =>
      _prefs.setBool(_keyPearNaturalRoots, v);

  List<int> loadCadPool() => _intList(_keyCadPool);
  bool loadCadMinor() => _prefs.getBool(_keyCadMinor) ?? false;
  int loadCadTempo() => _prefs.getInt(_keyCadTempo) ?? 1;
  bool loadCadNaturalRoots() => _prefs.getBool(_keyCadNaturalRoots) ?? true;

  Future<void> saveCadPool(List<int> indices) =>
      _prefs.setString(_keyCadPool, indices.join(','));
  Future<void> saveCadMinor(bool v) => _prefs.setBool(_keyCadMinor, v);
  Future<void> saveCadTempo(int index) => _prefs.setInt(_keyCadTempo, index);
  Future<void> saveCadNaturalRoots(bool v) =>
      _prefs.setBool(_keyCadNaturalRoots, v);
}
