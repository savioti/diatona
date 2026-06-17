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
  String get menuReference => 'Referência';

  @override
  String get menuTools => 'Ferramentas';

  @override
  String get comingSoon => 'Em Breve';

  @override
  String get noteTrainerDisplayModeLabel => 'Modo de Exibição';

  @override
  String get noteLevelStandard => 'Padrão';

  @override
  String get noteLevelAccidentals => 'Com Acidentes';

  @override
  String get chordDisplay => 'Exibição de Acordes';

  @override
  String get displayModeSymbol => 'Símbolo';

  @override
  String get displayModeTrebleClef => 'Clave de Sol';

  @override
  String get displayModeBassClef => 'Clave de Fá';

  @override
  String get displayModeLetterNames => 'Nomes das Notas';

  @override
  String get displayModeGuitar => 'Guitarra';

  @override
  String get displayModeUkulele => 'Ukulele';

  @override
  String refLoadError(String error) {
    return 'Erro ao carregar referências: $error';
  }

  @override
  String get refHowItWorksTooltip => 'Como funciona';

  @override
  String get refTapKeyToExplore => 'Toque uma tonalidade para explorar';

  @override
  String get refAscendingFifths => '5ªs ascendentes (horário) →';

  @override
  String get refAscendingFourths => '← 4ªs ascendentes (anti-horário)';

  @override
  String get refNoAccidentals => 'Sem acidentes';

  @override
  String get refKeySignature => 'Armadura';

  @override
  String get refDiatonicChords => 'Acordes diatônicos';

  @override
  String get refTapChordFunction => 'Toque um acorde para ver sua função';

  @override
  String get refTapLevelExpand => 'Toque um nível para expandir subdivisões';

  @override
  String get refWholeStepLegend => 'I = intervalo inteiro (2 casas)';

  @override
  String get refHalfStepLegend => 'M = meio-tom (1 casa)';

  @override
  String get refMinorNatural => 'Natural';

  @override
  String get refMinorHarmonic => 'Harmônica';

  @override
  String get refMinorMelodic => 'Melódica';

  @override
  String refScaleNotesFrom(String note, String parentKey) {
    return 'Notas da escala (a partir de $note, usando $parentKey):';
  }

  @override
  String get refModeFormula => 'Fórmula';

  @override
  String get refModeCharacteristic => 'Característica';

  @override
  String get refModeMood => 'Clima';

  @override
  String get refPentatonicLegend =>
      '● = nota  ⊙ = fundamental  Toque as caixas para alternar';

  @override
  String get refFnTonic => 'Tônica';

  @override
  String get refFnSubdominant => 'Subdom.';

  @override
  String get refFnDominant => 'Dom.';

  @override
  String get aboutAppDescription =>
      'Treinador de reconhecimento de acordes. Toque a nota fundamental no seu instrumento e treine o ouvido.';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Padrão do sistema';

  @override
  String get menuEarTrainer => 'Treinador de Ouvido';

  @override
  String get earTrainerDirection => 'Direção';

  @override
  String get earTrainerAscending => 'Ascendente';

  @override
  String get earTrainerDescending => 'Descendente';

  @override
  String get earTrainerHarmonic => 'Harmônico';

  @override
  String get earTrainerRandom => 'Aleatório';

  @override
  String get earTrainerCustom => 'Personalizado';

  @override
  String get earTrainerSelectAtLeastTwo => 'Selecione ao menos 2 intervalos';

  @override
  String get earTrainerWhatInterval => 'Que intervalo é esse?';

  @override
  String get earTrainerWrong => 'Errado!';

  @override
  String get intervalMinSecond => '2ª menor';

  @override
  String get intervalMajSecond => '2ª maior';

  @override
  String get intervalMinThird => '3ª menor';

  @override
  String get intervalMajThird => '3ª maior';

  @override
  String get intervalPerfectFourth => '4ª justa';

  @override
  String get intervalTritone => 'Trítono';

  @override
  String get intervalPerfectFifth => '5ª justa';

  @override
  String get intervalMinSixth => '6ª menor';

  @override
  String get intervalMajSixth => '6ª maior';

  @override
  String get intervalMinSeventh => '7ª menor';

  @override
  String get intervalMajSeventh => '7ª maior';

  @override
  String get intervalOctave => 'Oitava';

  @override
  String get rmChooseRoadmap => 'Escolha um Roteiro';

  @override
  String get rmChooseRoadmapSubtitle =>
      'Selecione um instrumento ou assunto para iniciar seu caminho de aprendizado.';

  @override
  String get rmChangeRoadmap => 'Trocar';

  @override
  String rmTopicsCompleted(int completed, int total) {
    return '$completed / $total tópicos concluídos';
  }

  @override
  String get rmObjectives => 'Objetivos';

  @override
  String get rmCommonMistakes => 'Erros Comuns';

  @override
  String get rmPracticeTips => 'Dicas de Prática';

  @override
  String get rmTags => 'Tags';

  @override
  String get rmResources => 'Recursos';

  @override
  String get rmTakeQuiz => 'Fazer Quiz';

  @override
  String get rmMarkComplete => 'Marcar como Concluído';

  @override
  String get rmMarkIncomplete => 'Marcar como Incompleto';

  @override
  String get rmQuiz => 'Quiz';

  @override
  String rmQuizScore(int correct, int total) {
    return '$correct / $total corretas';
  }

  @override
  String rmQuizPerfect(int correct, int total) {
    return 'Pontuação perfeita! $correct / $total corretas';
  }

  @override
  String get rmQuizSubmit => 'Enviar';

  @override
  String get rmQuizDone => 'Concluir';

  @override
  String get rmQuizRetake => 'Refazer';

  @override
  String rmLoadError(String error) {
    return 'Erro: $error';
  }

  @override
  String get rmDismiss => 'Fechar';
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
  String get menuReference => 'Referência';

  @override
  String get menuTools => 'Ferramentas';

  @override
  String get comingSoon => 'Em Breve';

  @override
  String get noteTrainerDisplayModeLabel => 'Modo de Exibição';

  @override
  String get noteLevelStandard => 'Padrão';

  @override
  String get noteLevelAccidentals => 'Com Acidentes';

  @override
  String get chordDisplay => 'Exibição de Acordes';

  @override
  String get displayModeSymbol => 'Símbolo';

  @override
  String get displayModeTrebleClef => 'Clave de Sol';

  @override
  String get displayModeBassClef => 'Clave de Fá';

  @override
  String get displayModeLetterNames => 'Nomes das Notas';

  @override
  String get displayModeGuitar => 'Guitarra';

  @override
  String get displayModeUkulele => 'Ukulele';

  @override
  String refLoadError(String error) {
    return 'Erro ao carregar referências: $error';
  }

  @override
  String get refHowItWorksTooltip => 'Como funciona';

  @override
  String get refTapKeyToExplore => 'Toque uma tonalidade para explorar';

  @override
  String get refAscendingFifths => '5ªs ascendentes (horário) →';

  @override
  String get refAscendingFourths => '← 4ªs ascendentes (anti-horário)';

  @override
  String get refNoAccidentals => 'Sem acidentes';

  @override
  String get refKeySignature => 'Armadura';

  @override
  String get refDiatonicChords => 'Acordes diatônicos';

  @override
  String get refTapChordFunction => 'Toque um acorde para ver sua função';

  @override
  String get refTapLevelExpand => 'Toque um nível para expandir subdivisões';

  @override
  String get refWholeStepLegend => 'I = intervalo inteiro (2 casas)';

  @override
  String get refHalfStepLegend => 'M = meio-tom (1 casa)';

  @override
  String get refMinorNatural => 'Natural';

  @override
  String get refMinorHarmonic => 'Harmônica';

  @override
  String get refMinorMelodic => 'Melódica';

  @override
  String refScaleNotesFrom(String note, String parentKey) {
    return 'Notas da escala (a partir de $note, usando $parentKey):';
  }

  @override
  String get refModeFormula => 'Fórmula';

  @override
  String get refModeCharacteristic => 'Característica';

  @override
  String get refModeMood => 'Clima';

  @override
  String get refPentatonicLegend =>
      '● = nota  ⊙ = fundamental  Toque as caixas para alternar';

  @override
  String get refFnTonic => 'Tônica';

  @override
  String get refFnSubdominant => 'Subdom.';

  @override
  String get refFnDominant => 'Dom.';

  @override
  String get aboutAppDescription =>
      'Treinador de reconhecimento de acordes. Toque a nota fundamental no seu instrumento e treine o ouvido.';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Padrão do sistema';

  @override
  String get menuEarTrainer => 'Treinador de Ouvido';

  @override
  String get earTrainerDirection => 'Direção';

  @override
  String get earTrainerAscending => 'Ascendente';

  @override
  String get earTrainerDescending => 'Descendente';

  @override
  String get earTrainerHarmonic => 'Harmônico';

  @override
  String get earTrainerRandom => 'Aleatório';

  @override
  String get earTrainerCustom => 'Personalizado';

  @override
  String get earTrainerSelectAtLeastTwo => 'Selecione ao menos 2 intervalos';

  @override
  String get earTrainerWhatInterval => 'Que intervalo é esse?';

  @override
  String get earTrainerWrong => 'Errado!';

  @override
  String get intervalMinSecond => '2ª menor';

  @override
  String get intervalMajSecond => '2ª maior';

  @override
  String get intervalMinThird => '3ª menor';

  @override
  String get intervalMajThird => '3ª maior';

  @override
  String get intervalPerfectFourth => '4ª justa';

  @override
  String get intervalTritone => 'Trítono';

  @override
  String get intervalPerfectFifth => '5ª justa';

  @override
  String get intervalMinSixth => '6ª menor';

  @override
  String get intervalMajSixth => '6ª maior';

  @override
  String get intervalMinSeventh => '7ª menor';

  @override
  String get intervalMajSeventh => '7ª maior';

  @override
  String get intervalOctave => 'Oitava';

  @override
  String get rmChooseRoadmap => 'Escolha um Roteiro';

  @override
  String get rmChooseRoadmapSubtitle =>
      'Selecione um instrumento ou assunto para iniciar seu caminho de aprendizado.';

  @override
  String get rmChangeRoadmap => 'Trocar';

  @override
  String rmTopicsCompleted(int completed, int total) {
    return '$completed / $total tópicos concluídos';
  }

  @override
  String get rmObjectives => 'Objetivos';

  @override
  String get rmCommonMistakes => 'Erros Comuns';

  @override
  String get rmPracticeTips => 'Dicas de Prática';

  @override
  String get rmTags => 'Tags';

  @override
  String get rmResources => 'Recursos';

  @override
  String get rmTakeQuiz => 'Fazer Quiz';

  @override
  String get rmMarkComplete => 'Marcar como Concluído';

  @override
  String get rmMarkIncomplete => 'Marcar como Incompleto';

  @override
  String get rmQuiz => 'Quiz';

  @override
  String rmQuizScore(int correct, int total) {
    return '$correct / $total corretas';
  }

  @override
  String rmQuizPerfect(int correct, int total) {
    return 'Pontuação perfeita! $correct / $total corretas';
  }

  @override
  String get rmQuizSubmit => 'Enviar';

  @override
  String get rmQuizDone => 'Concluir';

  @override
  String get rmQuizRetake => 'Refazer';

  @override
  String rmLoadError(String error) {
    return 'Erro: $error';
  }

  @override
  String get rmDismiss => 'Fechar';
}
