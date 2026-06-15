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
  String get comingSoon => 'Próximamente';
}
