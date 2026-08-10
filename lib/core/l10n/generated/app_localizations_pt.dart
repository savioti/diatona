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
  String get menuTraining => 'Treinamento';

  @override
  String get menuNoteTrainer => 'Treinador de Notas';

  @override
  String get menuChordTraining => 'Treino de Acordes';

  @override
  String get menuAbout => 'Sobre';

  @override
  String get menuCredits => 'Créditos';

  @override
  String get creditsOpenSourceLicenses => 'Licenças de código aberto';

  @override
  String get creditsOpenSourceLicensesSubtitle =>
      'Licenças dos pacotes usados por este app';

  @override
  String get menuReference => 'Referência';

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
  String get trainingCustom => 'Personalizado';

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
  String get menuScaleTrainer => 'Treino de Escalas';

  @override
  String get trainingDirection => 'Direção';

  @override
  String get trainingAscending => 'Ascendente';

  @override
  String get trainingDescending => 'Descendente';

  @override
  String get trainingUpAndDown => 'Subir e descer';

  @override
  String get trainingKeys => 'Tonalidades';

  @override
  String get trainingKeysNaturals => 'Naturais';

  @override
  String get trainingKeysAll => 'Todas';

  @override
  String get trainingPlayInOrder => 'Toque as notas por ordem';

  @override
  String get trainingFindTheNotes => 'Descubra as notas e toque-as por ordem';

  @override
  String get trainingShowNotes => 'Mostrar as notas';

  @override
  String get trainingShowNotesHelpTitle => 'Mostrar as Notas';

  @override
  String get trainingShowNotesHelpBody =>
      'Quando ativado, as notas são listadas antes de as tocar. Quando desativado, apenas o nome é mostrado e as notas ficam por sua conta. Em qualquer dos casos, três notas erradas avançam para o exercício seguinte.';

  @override
  String get trainingMissed => 'Falhou';

  @override
  String trainingRootLabel(String root, String name) {
    return '$root $name';
  }

  @override
  String get scaleMajor => 'Maior';

  @override
  String get scaleNaturalMinor => 'Menor Natural';

  @override
  String get scaleDorian => 'Dórico';

  @override
  String get scaleMixolydian => 'Mixolídio';

  @override
  String get scaleLydian => 'Lídio';

  @override
  String get scalePhrygian => 'Frígio';

  @override
  String get scaleLocrian => 'Lócrio';

  @override
  String get scaleHarmonicMinor => 'Menor Harmónica';

  @override
  String get scaleMelodicMinor => 'Menor Melódica';

  @override
  String get menuArpeggioTrainer => 'Treino de Arpejos';

  @override
  String get arpeggioInversion => 'Inversão';

  @override
  String get arpeggioRootPosition => 'Posição fundamental';

  @override
  String get arpeggioFirstInversion => '1ª inversão';

  @override
  String get arpeggioSecondInversion => '2ª inversão';

  @override
  String get arpeggioThirdInversion => '3ª inversão';

  @override
  String get arpeggioRandomInversion => 'Aleatória';

  @override
  String get arpeggioOctaves => 'Oitavas';

  @override
  String get menuIntervalTrainer => 'Treino de Intervalos';

  @override
  String get trainingMixed => 'Misto';

  @override
  String get intervalPlayRoot => 'Tocar a fundamental';

  @override
  String get intervalPlayRootHelpTitle => 'Tocar a Fundamental';

  @override
  String get intervalPlayRootHelpBody =>
      'Quando ativado, o exercício tem duas notas: aquela de onde o intervalo parte e aquela onde chega. Quando desativado, apenas a nota de chegada é pedida, o que é mais rápido mas nunca faz soar o intervalo.';
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
  String get menuTraining => 'Treinamento';

  @override
  String get menuNoteTrainer => 'Treinador de Notas';

  @override
  String get menuChordTraining => 'Treino de Acordes';

  @override
  String get menuAbout => 'Sobre';

  @override
  String get menuCredits => 'Créditos';

  @override
  String get creditsOpenSourceLicenses => 'Licenças de código aberto';

  @override
  String get creditsOpenSourceLicensesSubtitle =>
      'Licenças dos pacotes usados por este app';

  @override
  String get menuReference => 'Referência';

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
  String get trainingCustom => 'Personalizado';

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
  String get menuScaleTrainer => 'Treino de Escalas';

  @override
  String get trainingDirection => 'Direção';

  @override
  String get trainingAscending => 'Ascendente';

  @override
  String get trainingDescending => 'Descendente';

  @override
  String get trainingUpAndDown => 'Subindo e descendo';

  @override
  String get trainingKeys => 'Tonalidades';

  @override
  String get trainingKeysNaturals => 'Naturais';

  @override
  String get trainingKeysAll => 'Todas';

  @override
  String get trainingPlayInOrder => 'Toque as notas em ordem';

  @override
  String get trainingFindTheNotes => 'Descubra as notas e toque em ordem';

  @override
  String get trainingShowNotes => 'Mostrar as notas';

  @override
  String get trainingShowNotesHelpTitle => 'Mostrar as Notas';

  @override
  String get trainingShowNotesHelpBody =>
      'Quando ativado, as notas são listadas antes de você tocá-las. Quando desativado, apenas o nome aparece e as notas ficam por sua conta. Nos dois casos, três notas erradas passam para o próximo exercício.';

  @override
  String get trainingMissed => 'Falhou';

  @override
  String trainingRootLabel(String root, String name) {
    return '$root $name';
  }

  @override
  String get scaleMajor => 'Maior';

  @override
  String get scaleNaturalMinor => 'Menor Natural';

  @override
  String get scaleDorian => 'Dórico';

  @override
  String get scaleMixolydian => 'Mixolídio';

  @override
  String get scaleLydian => 'Lídio';

  @override
  String get scalePhrygian => 'Frígio';

  @override
  String get scaleLocrian => 'Lócrio';

  @override
  String get scaleHarmonicMinor => 'Menor Harmônica';

  @override
  String get scaleMelodicMinor => 'Menor Melódica';

  @override
  String get menuArpeggioTrainer => 'Treino de Arpejos';

  @override
  String get arpeggioInversion => 'Inversão';

  @override
  String get arpeggioRootPosition => 'Posição fundamental';

  @override
  String get arpeggioFirstInversion => '1ª inversão';

  @override
  String get arpeggioSecondInversion => '2ª inversão';

  @override
  String get arpeggioThirdInversion => '3ª inversão';

  @override
  String get arpeggioRandomInversion => 'Aleatória';

  @override
  String get arpeggioOctaves => 'Oitavas';

  @override
  String get menuIntervalTrainer => 'Treino de Intervalos';

  @override
  String get trainingMixed => 'Misto';

  @override
  String get intervalPlayRoot => 'Tocar a fundamental';

  @override
  String get intervalPlayRootHelpTitle => 'Tocar a Fundamental';

  @override
  String get intervalPlayRootHelpBody =>
      'Quando ativado, o exercício tem duas notas: a nota de onde o intervalo parte e a nota onde ele chega. Quando desativado, apenas a nota de chegada é pedida, o que é mais rápido mas nunca faz o intervalo soar.';
}
