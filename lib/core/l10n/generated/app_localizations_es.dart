// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Diatona';

  @override
  String get homeTitle => 'Entrenamiento de Acordes';

  @override
  String get getReady => 'Prepárate';

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Detener';

  @override
  String get next => 'Siguiente';

  @override
  String get correct => '¡Correcto!';

  @override
  String get skipped => 'Omitido';

  @override
  String get level => 'Nivel';

  @override
  String get timeLimit => 'Límite de tiempo';

  @override
  String get noTimeLimit => '∞';

  @override
  String seconds(int n) {
    return '${n}s';
  }

  @override
  String get levelMajor => 'Mayor';

  @override
  String get levelMinor => 'Menor';

  @override
  String get levelAug => 'Aumentado';

  @override
  String get levelDim => 'Disminuido';

  @override
  String get levelSus => 'Suspendido';

  @override
  String get levelSeventh => '7ª';

  @override
  String get levelMaj7 => 'Mayor 7ª';

  @override
  String get levelM7 => 'Menor 7ª';

  @override
  String get levelDim7 => 'Disminuido 7ª';

  @override
  String get levelHalfDim7 => 'Semidisminuido 7ª';

  @override
  String get levelMMaj7 => 'Menor-Mayor 7ª';

  @override
  String get levelAugMaj7 => 'Aumentado-Mayor 7ª';

  @override
  String levelLabel(int number, String name) {
    return 'Nivel $number: $name';
  }

  @override
  String get chordPool => 'Grupo de acordes';

  @override
  String chordsCount(int count) {
    return '$count acordes';
  }

  @override
  String get cumulativePool => 'Grupo acumulativo';

  @override
  String get cumulativePoolHelpTitle => 'Grupo Acumulativo';

  @override
  String get cumulativePoolHelpBody =>
      'Cuando está activado, el grupo de acordes incluye todos los tipos desde el nivel 1 hasta el nivel seleccionado. Cuando está desactivado, solo se usa el tipo de acorde del nivel seleccionado.';

  @override
  String get ok => 'OK';

  @override
  String get settings => 'Ajustes';

  @override
  String get theme => 'Tema';

  @override
  String get menuTraining => 'Entrenamiento';

  @override
  String get menuNoteTrainer => 'Entrenador de Notas';

  @override
  String get menuChordTraining => 'Entrenamiento de Acordes';

  @override
  String get menuAbout => 'Acerca de';

  @override
  String get menuCredits => 'Créditos';

  @override
  String get creditsOpenSourceLicenses => 'Licencias de código abierto';

  @override
  String get creditsOpenSourceLicensesSubtitle =>
      'Licencias de los paquetes usados por esta app';

  @override
  String get menuReference => 'Referencia';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get noteTrainerDisplayModeLabel => 'Modo de Visualización';

  @override
  String get noteLevelStandard => 'Estándar';

  @override
  String get noteLevelAccidentals => 'Con Alteraciones';

  @override
  String get chordDisplay => 'Visualización de Acordes';

  @override
  String get displayModeSymbol => 'Símbolo';

  @override
  String get displayModeTrebleClef => 'Clave de Sol';

  @override
  String get displayModeBassClef => 'Clave de Fa';

  @override
  String get displayModeLetterNames => 'Nombres de Notas';

  @override
  String get displayModeGuitar => 'Guitarra';

  @override
  String get displayModeUkulele => 'Ukulele';

  @override
  String refLoadError(String error) {
    return 'Error al cargar referencias: $error';
  }

  @override
  String get refHowItWorksTooltip => 'Cómo funciona';

  @override
  String get refTapKeyToExplore => 'Toca una tonalidad para explorar';

  @override
  String get refAscendingFifths => '5ªs ascendentes (horario) →';

  @override
  String get refAscendingFourths => '← 4ªs ascendentes (antihorario)';

  @override
  String get refNoAccidentals => 'Sin alteraciones';

  @override
  String get refKeySignature => 'Armadura';

  @override
  String get refDiatonicChords => 'Acordes diatónicos';

  @override
  String get refTapChordFunction => 'Toca un acorde para ver su función';

  @override
  String get refTapLevelExpand => 'Toca un nivel para expandir subdivisiones';

  @override
  String get refWholeStepLegend => 'E = tono entero (2 trastes)';

  @override
  String get refHalfStepLegend => 'S = semitono (1 traste)';

  @override
  String get refMinorNatural => 'Natural';

  @override
  String get refMinorHarmonic => 'Armónica';

  @override
  String get refMinorMelodic => 'Melódica';

  @override
  String refScaleNotesFrom(String note, String parentKey) {
    return 'Notas de la escala (desde $note, usando $parentKey):';
  }

  @override
  String get refModeFormula => 'Fórmula';

  @override
  String get refModeCharacteristic => 'Característica';

  @override
  String get refModeMood => 'Ambiente';

  @override
  String get refPentatonicLegend =>
      '● = nota  ⊙ = fundamental  Toca las cajas para alternar';

  @override
  String get refFnTonic => 'Tónica';

  @override
  String get refFnSubdominant => 'Subdom.';

  @override
  String get refFnDominant => 'Dom.';

  @override
  String get aboutAppDescription =>
      'Entrenador de reconocimiento de acordes. Toca la nota fundamental en tu instrumento y entrena tu oído.';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Idioma del sistema';

  @override
  String get menuEarTrainer => 'Entrenador de Oído';

  @override
  String get earTrainerDirection => 'Dirección';

  @override
  String get earTrainerAscending => 'Ascendente';

  @override
  String get earTrainerDescending => 'Descendente';

  @override
  String get earTrainerHarmonic => 'Armónico';

  @override
  String get earTrainerRandom => 'Aleatorio';

  @override
  String get trainingCustom => 'Personalizado';

  @override
  String get earTrainerSelectAtLeastTwo => 'Selecciona al menos 2 intervalos';

  @override
  String get earTrainerWhatInterval => '¿Qué intervalo es este?';

  @override
  String get earTrainerWrong => '¡Incorrecto!';

  @override
  String get intervalMinSecond => '2ª menor';

  @override
  String get intervalMajSecond => '2ª mayor';

  @override
  String get intervalMinThird => '3ª menor';

  @override
  String get intervalMajThird => '3ª mayor';

  @override
  String get intervalPerfectFourth => '4ª justa';

  @override
  String get intervalTritone => 'Trítono';

  @override
  String get intervalPerfectFifth => '5ª justa';

  @override
  String get intervalMinSixth => '6ª menor';

  @override
  String get intervalMajSixth => '6ª mayor';

  @override
  String get intervalMinSeventh => '7ª menor';

  @override
  String get intervalMajSeventh => '7ª mayor';

  @override
  String get intervalOctave => 'Octava';

  @override
  String get menuScaleTrainer => 'Entrenador de Escalas';

  @override
  String get trainingDirection => 'Dirección';

  @override
  String get trainingAscending => 'Ascendente';

  @override
  String get trainingDescending => 'Descendente';

  @override
  String get trainingUpAndDown => 'Subiendo y bajando';

  @override
  String get trainingKeys => 'Tonalidades';

  @override
  String get trainingKeysNaturals => 'Naturales';

  @override
  String get trainingKeysAll => 'Todas';

  @override
  String get trainingPlayInOrder => 'Toca las notas en orden';

  @override
  String get trainingFindTheNotes => 'Deduce las notas y tócalas en orden';

  @override
  String get trainingShowNotes => 'Mostrar las notas';

  @override
  String get trainingShowNotesHelpTitle => 'Mostrar las Notas';

  @override
  String get trainingShowNotesHelpBody =>
      'Cuando está activado, las notas se muestran antes de tocarlas. Cuando está desactivado, solo aparece el nombre y las notas corren por tu cuenta. En ambos casos, tres notas erradas pasan al siguiente ejercicio.';

  @override
  String get trainingMissed => 'Fallaste';

  @override
  String trainingRootLabel(String root, String name) {
    return '$root $name';
  }

  @override
  String get scaleMajor => 'Mayor';

  @override
  String get scaleNaturalMinor => 'Menor Natural';

  @override
  String get scaleDorian => 'Dórico';

  @override
  String get scaleMixolydian => 'Mixolidio';

  @override
  String get scaleLydian => 'Lidio';

  @override
  String get scalePhrygian => 'Frigio';

  @override
  String get scaleLocrian => 'Locrio';

  @override
  String get scaleHarmonicMinor => 'Menor Armónica';

  @override
  String get scaleMelodicMinor => 'Menor Melódica';

  @override
  String get menuArpeggioTrainer => 'Entrenador de Arpegios';

  @override
  String get arpeggioInversion => 'Inversión';

  @override
  String get arpeggioRootPosition => 'Estado fundamental';

  @override
  String get arpeggioFirstInversion => '1ª inversión';

  @override
  String get arpeggioSecondInversion => '2ª inversión';

  @override
  String get arpeggioThirdInversion => '3ª inversión';

  @override
  String get arpeggioRandomInversion => 'Aleatoria';

  @override
  String get arpeggioOctaves => 'Octavas';

  @override
  String get menuIntervalTrainer => 'Entrenador de Intervalos';

  @override
  String get trainingMixed => 'Mixto';

  @override
  String get intervalPlayRoot => 'Tocar la fundamental';

  @override
  String get intervalPlayRootHelpTitle => 'Tocar la Fundamental';

  @override
  String get intervalPlayRootHelpBody =>
      'Cuando está activado, el ejercicio son dos notas: la nota desde la que parte el intervalo y la nota a la que llega. Cuando está desactivado, solo se pide la nota de llegada, lo que es más rápido pero nunca hace sonar el intervalo.';

  @override
  String get playbackPlaying => 'Sonando…';

  @override
  String get playbackReplay => 'Repetir';

  @override
  String get refProgressionsArpeggiate => 'Arpegiar';

  @override
  String get refProgressionsSlow => 'Lento';

  @override
  String get refProgressionsMedium => 'Medio';

  @override
  String get refProgressionsFast => 'Rápido';

  @override
  String get refModulationFrom => 'Desde';

  @override
  String get refModulationTo => 'Hacia';

  @override
  String refModulationDistance(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pasos en el círculo de quintas',
      one: '1 paso en el círculo de quintas',
      zero: 'La misma tónica',
    );
    return '$_temp0';
  }

  @override
  String refModulationSharedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count acordes en común',
      one: '1 acorde en común',
      zero: 'Ningún acorde en común',
    );
    return '$_temp0';
  }

  @override
  String get refModulationNoPivots =>
      'Estas dos tonalidades no tienen ningún acorde en común, así que no hay pivote sobre el que girar. Pasar de una a otra exige un acorde que no pertenece a ninguna de las dos.';

  @override
  String get refModulationTapPivot =>
      'Toca un acorde en común para oírlo girar: el pivote, y después la dominante y la tónica de la tonalidad de llegada.';

  @override
  String get menuRomanTrainer => 'Grados Romanos';

  @override
  String get menuProgressionTrainer => 'Entrenador de Progresiones';

  @override
  String get menuProgressionEarTrainer => 'Progresiones al Oído';

  @override
  String get menuCadenceTrainer => 'Cadencias';

  @override
  String get progressionPool => 'Progresiones';

  @override
  String get progressionTempo => 'Tempo';

  @override
  String get progressionTrainerHint =>
      'Los grados se muestran, los acordes no. Averiguar qué acordes son en esta tonalidad es el ejercicio.';

  @override
  String get progressionArpeggiate => 'Arpegiar los acordes';

  @override
  String get progressionArpeggiateHelpTitle => 'Arpegiar los Acordes';

  @override
  String get progressionArpeggiateHelpBody =>
      'Cuando está activado, el ejercicio pide todas las notas de cada acorde y no solo las fundamentales, así que una progresión de cuatro acordes son doce notas. Cuando está desactivado, solo se pide la fundamental de cada acorde, que es la progresión como línea de bajo.';

  @override
  String get progressionArpeggiatePlaybackHelpTitle => 'Arpegiar';

  @override
  String get progressionArpeggiatePlaybackHelpBody =>
      'Cuando está activado, las notas de cada acorde llegan una tras otra en vez de juntas. Así es más fácil separar el acorde, y más difícil oír la progresión como un todo.';

  @override
  String get progressionEarWhich => '¿Qué progresión?';

  @override
  String get progressionEarHint =>
      'Elige al menos dos. Cada ejercicio toca una de ellas en una tonalidad al azar.';

  @override
  String get cadencePool => 'Cadencias';

  @override
  String get cadenceWhich => '¿Qué cadencia?';

  @override
  String get cadenceHint =>
      'Cada ejercicio empieza en la tónica, para que la tonalidad se oiga antes de que llegue la cadencia.';

  @override
  String get cadenceAuthentic => 'Auténtica';

  @override
  String get cadencePlagal => 'Plagal';

  @override
  String get cadenceHalf => 'Suspensiva';

  @override
  String get cadenceDeceptive => 'Rota';

  @override
  String get cadenceIncludeMinor => 'Incluir tonalidades menores';

  @override
  String get cadenceIncludeMinorHelpTitle => 'Incluir Tonalidades Menores';

  @override
  String get cadenceIncludeMinorHelpBody =>
      'Cuando está activado, la mitad de los ejercicios está en una tonalidad menor. El menor usa la escala menor armónica, que es la que da a la cadencia el quinto grado mayor que necesita.';

  @override
  String get romanDirection => 'Sentido';

  @override
  String get romanScales => 'Escalas';

  @override
  String get romanModeNumeralToChord => 'Grado → Acorde';

  @override
  String get romanModeChordToNumeral => 'Acorde → Grado';

  @override
  String get romanWhichChord => '¿Qué acorde es este grado?';

  @override
  String get romanWhichDegree => '¿Qué grado es este acorde?';

  @override
  String get romanSevenths => 'Acordes de séptima';

  @override
  String get romanSeventhsHelpTitle => 'Acordes de Séptima';

  @override
  String get romanSeventhsHelpBody =>
      'Cuando está activado, los grados llevan una tercera más apilada, así que el quinto grado de una tonalidad mayor es V7 y no V. Son los mismos siete grados, nombrados con más precisión.';

  @override
  String get romanHearChord => 'Oír el acorde';

  @override
  String get romanHearChordHelpTitle => 'Oír el Acorde';

  @override
  String get romanHearChordHelpBody =>
      'Cuando está activado, el acorde suena en cuanto se revela la respuesta. Nombrar un grado es un ejercicio sobre papel mientras no se haya oído cómo suena.';
}
