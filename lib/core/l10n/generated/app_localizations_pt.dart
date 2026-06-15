// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Diatona';

  @override
  String get homeTitle => 'Treino de Acordes';

  @override
  String get getReady => 'Prepare-se';

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Parar';

  @override
  String get next => 'Próximo';

  @override
  String get correct => 'Correto!';

  @override
  String get skipped => 'Pulado';

  @override
  String get level => 'Nível';

  @override
  String get timeLimit => 'Limite de Tempo';

  @override
  String get noTimeLimit => '∞';

  @override
  String seconds(int n) {
    return '${n}s';
  }

  @override
  String get levelMajor => 'Maior';

  @override
  String get levelMinor => 'Menor';

  @override
  String get levelAug => 'Aumentado';

  @override
  String get levelDim => 'Diminuto';

  @override
  String get levelSus => 'Suspenso';

  @override
  String get levelSeventh => '7ª';

  @override
  String get levelMaj7 => 'Maior 7ª';

  @override
  String get levelM7 => 'Menor 7ª';

  @override
  String get levelDim7 => 'Diminuto 7ª';

  @override
  String get levelHalfDim7 => 'Meio-Diminuto 7ª';

  @override
  String get levelMMaj7 => 'Menor-Maior 7ª';

  @override
  String get levelAugMaj7 => 'Aumentado-Maior 7ª';

  @override
  String levelLabel(int number, String name) {
    return 'Nível $number: $name';
  }

  @override
  String get chordPool => 'Pool de Acordes';

  @override
  String chordsCount(int count) {
    return '$count acordes';
  }

  @override
  String get cumulativePool => 'Pool cumulativo';

  @override
  String get cumulativePoolHelpTitle => 'Pool Cumulativo';

  @override
  String get cumulativePoolHelpBody =>
      'Quando ativado, o pool de acordes inclui todos os tipos do nível 1 até o nível selecionado. Quando desativado, apenas o tipo de acorde do nível selecionado é utilizado.';

  @override
  String get ok => 'OK';

  @override
  String get settings => 'Configurações';

  @override
  String get theme => 'Tema';

  @override
  String get menuLearning => 'Aprendizado';

  @override
  String get menuTraining => 'Treinamento';

  @override
  String get menuNoteTrainer => 'Treinador de Notas';

  @override
  String get menuChordTraining => 'Treino de Acordes';

  @override
  String get menuDonate => 'Doar';

  @override
  String get menuAbout => 'Sobre';

  @override
  String get menuCredits => 'Créditos';

  @override
  String get comingSoon => 'Em Breve';

  @override
  String get noteTrainerClefLabel => 'Clave';

  @override
  String get noteLevelStandard => 'Padrão';

  @override
  String get noteLevelAccidentals => 'Acidentes';

  @override
  String get chordDisplay => 'Exibição de Acorde';

  @override
  String get displayModeSymbol => 'Símbolo';

  @override
  String get displayModeTrebleClef => 'Clave de Sol';

  @override
  String get displayModeBassClef => 'Clave de Fá';

  @override
  String get displayModeGuitar => 'Guitarra';

  @override
  String get displayModeUkulele => 'Ukulele';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Diatona';

  @override
  String get homeTitle => 'Treino de Acordes';

  @override
  String get getReady => 'Prepare-se';

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Parar';

  @override
  String get next => 'Próximo';

  @override
  String get correct => 'Correto!';

  @override
  String get skipped => 'Pulado';

  @override
  String get level => 'Nível';

  @override
  String get timeLimit => 'Limite de Tempo';

  @override
  String get noTimeLimit => '∞';

  @override
  String seconds(int n) {
    return '${n}s';
  }

  @override
  String get levelMajor => 'Maior';

  @override
  String get levelMinor => 'Menor';

  @override
  String get levelAug => 'Aumentado';

  @override
  String get levelDim => 'Diminuto';

  @override
  String get levelSus => 'Suspenso';

  @override
  String get levelSeventh => '7ª';

  @override
  String get levelMaj7 => 'Maior 7ª';

  @override
  String get levelM7 => 'Menor 7ª';

  @override
  String get levelDim7 => 'Diminuto 7ª';

  @override
  String get levelHalfDim7 => 'Meio-Diminuto 7ª';

  @override
  String get levelMMaj7 => 'Menor-Maior 7ª';

  @override
  String get levelAugMaj7 => 'Aumentado-Maior 7ª';

  @override
  String levelLabel(int number, String name) {
    return 'Nível $number: $name';
  }

  @override
  String get chordPool => 'Pool de Acordes';

  @override
  String chordsCount(int count) {
    return '$count acordes';
  }

  @override
  String get cumulativePool => 'Pool cumulativo';

  @override
  String get cumulativePoolHelpTitle => 'Pool Cumulativo';

  @override
  String get cumulativePoolHelpBody =>
      'Quando ativado, o pool de acordes inclui todos os tipos do nível 1 até o nível selecionado. Quando desativado, apenas o tipo de acorde do nível selecionado é utilizado.';

  @override
  String get ok => 'OK';

  @override
  String get settings => 'Configurações';

  @override
  String get theme => 'Tema';

  @override
  String get menuLearning => 'Aprendizado';

  @override
  String get menuTraining => 'Treinamento';

  @override
  String get menuNoteTrainer => 'Treinador de Notas';

  @override
  String get menuChordTraining => 'Treino de Acordes';

  @override
  String get menuDonate => 'Doar';

  @override
  String get menuAbout => 'Sobre';

  @override
  String get menuCredits => 'Créditos';

  @override
  String get comingSoon => 'Em Breve';

  @override
  String get noteTrainerClefLabel => 'Clave';

  @override
  String get noteLevelStandard => 'Padrão';

  @override
  String get noteLevelAccidentals => 'Acidentes';

  @override
  String get chordDisplay => 'Exibição de Acorde';

  @override
  String get displayModeSymbol => 'Símbolo';

  @override
  String get displayModeTrebleClef => 'Clave de Sol';

  @override
  String get displayModeBassClef => 'Clave de Fá';

  @override
  String get displayModeGuitar => 'Guitarra';

  @override
  String get displayModeUkulele => 'Ukulele';
}
