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
  String get menuLearning => 'Aprendizaje';

  @override
  String get menuTraining => 'Entrenamiento';

  @override
  String get menuNoteTrainer => 'Entrenador de Notas';

  @override
  String get menuChordTraining => 'Entrenamiento de Acordes';

  @override
  String get menuDonate => 'Donar';

  @override
  String get menuAbout => 'Acerca de';

  @override
  String get menuCredits => 'Créditos';

  @override
  String get menuReference => 'Referencia';

  @override
  String get menuTools => 'Herramientas';

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
  String get earTrainerCustom => 'Personalizado';

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
  String get rmChooseRoadmap => 'Elige un Mapa de Ruta';

  @override
  String get rmChooseRoadmapSubtitle =>
      'Selecciona un instrumento o tema para comenzar tu ruta de aprendizaje.';

  @override
  String get rmChangeRoadmap => 'Cambiar';

  @override
  String rmTopicsCompleted(int completed, int total) {
    return '$completed / $total temas completados';
  }

  @override
  String get rmObjectives => 'Objetivos';

  @override
  String get rmCommonMistakes => 'Errores Comunes';

  @override
  String get rmPracticeTips => 'Consejos de Práctica';

  @override
  String get rmTags => 'Etiquetas';

  @override
  String get rmResources => 'Recursos';

  @override
  String get rmTakeQuiz => 'Hacer Quiz';

  @override
  String get rmMarkComplete => 'Marcar como Completado';

  @override
  String get rmMarkIncomplete => 'Marcar como Incompleto';

  @override
  String get rmQuiz => 'Quiz';

  @override
  String rmQuizScore(int correct, int total) {
    return '$correct / $total correctas';
  }

  @override
  String rmQuizPerfect(int correct, int total) {
    return '¡Puntuación perfecta! $correct / $total correctas';
  }

  @override
  String get rmQuizSubmit => 'Enviar';

  @override
  String get rmQuizDone => 'Listo';

  @override
  String get rmQuizRetake => 'Repetir';

  @override
  String rmLoadError(String error) {
    return 'Error: $error';
  }

  @override
  String get rmDismiss => 'Cerrar';
}
