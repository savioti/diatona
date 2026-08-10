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

  @override
  String get playbackPlaying => 'A tocar…';

  @override
  String get playbackReplay => 'Repetir';

  @override
  String get refProgressionsArpeggiate => 'Arpejar';

  @override
  String get refProgressionsSlow => 'Lento';

  @override
  String get refProgressionsMedium => 'Médio';

  @override
  String get refProgressionsFast => 'Rápido';

  @override
  String get refModulationFrom => 'De';

  @override
  String get refModulationTo => 'Para';

  @override
  String refModulationDistance(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count passos no ciclo das quintas',
      one: '1 passo no ciclo das quintas',
      zero: 'A mesma tónica',
    );
    return '$_temp0';
  }

  @override
  String refModulationSharedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count acordes em comum',
      one: '1 acorde em comum',
      zero: 'Nenhum acorde em comum',
    );
    return '$_temp0';
  }

  @override
  String get refModulationNoPivots =>
      'Estas duas tonalidades não têm nenhum acorde em comum, por isso não há pivô onde girar. Passar de uma para a outra exige um acorde que não pertence a nenhuma delas.';

  @override
  String get refModulationTapPivot =>
      'Toque num acorde em comum para o ouvir girar: o pivô, depois a dominante e a tónica da tonalidade de chegada.';

  @override
  String get menuRomanTrainer => 'Graus Romanos';

  @override
  String get menuProgressionTrainer => 'Treino de Progressões';

  @override
  String get menuProgressionEarTrainer => 'Progressões de Ouvido';

  @override
  String get menuCadenceTrainer => 'Cadências';

  @override
  String get progressionPool => 'Progressões';

  @override
  String get progressionTempo => 'Andamento';

  @override
  String get progressionTrainerHint =>
      'Os graus são mostrados, os acordes não. Descobrir que acordes são nesta tonalidade é o exercício.';

  @override
  String get progressionArpeggiate => 'Arpejar os acordes';

  @override
  String get progressionArpeggiateHelpTitle => 'Arpejar os Acordes';

  @override
  String get progressionArpeggiateHelpBody =>
      'Quando ativado, o exercício pede todas as notas de cada acorde e não só as fundamentais, por isso uma progressão de quatro acordes são doze notas. Quando desativado, só a fundamental de cada acorde é pedida, que é a progressão como linha de baixo.';

  @override
  String get progressionArpeggiatePlaybackHelpTitle => 'Arpejar';

  @override
  String get progressionArpeggiatePlaybackHelpBody =>
      'Quando ativado, as notas de cada acorde chegam uma a seguir à outra em vez de juntas. Assim é mais fácil separar o acorde, e mais difícil ouvir a progressão como um todo.';

  @override
  String get progressionEarWhich => 'Que progressão?';

  @override
  String get progressionEarHint =>
      'Escolha pelo menos duas. Cada exercício toca uma delas numa tonalidade ao acaso.';

  @override
  String get cadencePool => 'Cadências';

  @override
  String get cadenceWhich => 'Que cadência?';

  @override
  String get cadenceHint =>
      'Todos os exercícios começam na tónica, para que a tonalidade se ouça antes de a cadência chegar.';

  @override
  String get cadenceAuthentic => 'Autêntica';

  @override
  String get cadencePlagal => 'Plagal';

  @override
  String get cadenceHalf => 'Suspensiva';

  @override
  String get cadenceDeceptive => 'Interrompida';

  @override
  String get cadenceIncludeMinor => 'Incluir tonalidades menores';

  @override
  String get cadenceIncludeMinorHelpTitle => 'Incluir Tonalidades Menores';

  @override
  String get cadenceIncludeMinorHelpBody =>
      'Quando ativado, metade dos exercícios está numa tonalidade menor. O menor usa a escala menor harmónica, que é a que dá à cadência o quinto grau maior de que precisa.';

  @override
  String get romanDirection => 'Sentido';

  @override
  String get romanScales => 'Escalas';

  @override
  String get romanModeNumeralToChord => 'Grau → Acorde';

  @override
  String get romanModeChordToNumeral => 'Acorde → Grau';

  @override
  String get romanWhichChord => 'Que acorde é este grau?';

  @override
  String get romanWhichDegree => 'Que grau é este acorde?';

  @override
  String get romanSevenths => 'Acordes de sétima';

  @override
  String get romanSeventhsHelpTitle => 'Acordes de Sétima';

  @override
  String get romanSeventhsHelpBody =>
      'Quando ativado, os graus levam mais uma terceira empilhada, por isso o quinto grau de uma tonalidade maior é V7 e não V. São os mesmos sete graus, nomeados com mais rigor.';

  @override
  String get romanHearChord => 'Ouvir o acorde';

  @override
  String get romanHearChordHelpTitle => 'Ouvir o Acorde';

  @override
  String get romanHearChordHelpBody =>
      'Quando ativado, o acorde toca assim que a resposta é revelada. Nomear um grau é um exercício escrito enquanto não se ouvir como ele soa.';
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

  @override
  String get playbackPlaying => 'Tocando…';

  @override
  String get playbackReplay => 'Repetir';

  @override
  String get refProgressionsArpeggiate => 'Arpejar';

  @override
  String get refProgressionsSlow => 'Lento';

  @override
  String get refProgressionsMedium => 'Médio';

  @override
  String get refProgressionsFast => 'Rápido';

  @override
  String get refModulationFrom => 'De';

  @override
  String get refModulationTo => 'Para';

  @override
  String refModulationDistance(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count passos no ciclo das quintas',
      one: '1 passo no ciclo das quintas',
      zero: 'A mesma tônica',
    );
    return '$_temp0';
  }

  @override
  String refModulationSharedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count acordes em comum',
      one: '1 acorde em comum',
      zero: 'Nenhum acorde em comum',
    );
    return '$_temp0';
  }

  @override
  String get refModulationNoPivots =>
      'Estes dois tons não têm nenhum acorde em comum, então não existe pivô para girar. Ir de um para o outro exige um acorde que não pertence a nenhum dos dois.';

  @override
  String get refModulationTapPivot =>
      'Toque em um acorde em comum para ouvi-lo girar: o pivô, depois a dominante e a tônica do tom de chegada.';

  @override
  String get menuRomanTrainer => 'Graus Romanos';

  @override
  String get menuProgressionTrainer => 'Treino de Progressões';

  @override
  String get menuProgressionEarTrainer => 'Progressões de Ouvido';

  @override
  String get menuCadenceTrainer => 'Cadências';

  @override
  String get progressionPool => 'Progressões';

  @override
  String get progressionTempo => 'Andamento';

  @override
  String get progressionTrainerHint =>
      'Os graus aparecem, os acordes não. Descobrir que acordes são neste tom é o exercício.';

  @override
  String get progressionArpeggiate => 'Arpejar os acordes';

  @override
  String get progressionArpeggiateHelpTitle => 'Arpejar os Acordes';

  @override
  String get progressionArpeggiateHelpBody =>
      'Quando ativado, o exercício pede todas as notas de cada acorde e não só as fundamentais, então uma progressão de quatro acordes vira doze notas. Quando desativado, só a fundamental de cada acorde é pedida, que é a progressão como linha de baixo.';

  @override
  String get progressionArpeggiatePlaybackHelpTitle => 'Arpejar';

  @override
  String get progressionArpeggiatePlaybackHelpBody =>
      'Quando ativado, as notas de cada acorde chegam uma depois da outra em vez de juntas. Assim fica mais fácil separar o acorde, e mais difícil ouvir a progressão como um todo.';

  @override
  String get progressionEarWhich => 'Qual progressão?';

  @override
  String get progressionEarHint =>
      'Escolha pelo menos duas. Cada exercício toca uma delas em um tom sorteado.';

  @override
  String get cadencePool => 'Cadências';

  @override
  String get cadenceWhich => 'Qual cadência?';

  @override
  String get cadenceHint =>
      'Todo exercício começa na tônica, para o tom ser ouvido antes de a cadência chegar.';

  @override
  String get cadenceAuthentic => 'Autêntica';

  @override
  String get cadencePlagal => 'Plagal';

  @override
  String get cadenceHalf => 'Suspensiva';

  @override
  String get cadenceDeceptive => 'Interrompida';

  @override
  String get cadenceIncludeMinor => 'Incluir tons menores';

  @override
  String get cadenceIncludeMinorHelpTitle => 'Incluir Tons Menores';

  @override
  String get cadenceIncludeMinorHelpBody =>
      'Quando ativado, metade dos exercícios fica em um tom menor. O menor usa a escala menor harmônica, que é a que dá à cadência o quinto grau maior de que ela precisa.';

  @override
  String get romanDirection => 'Sentido';

  @override
  String get romanScales => 'Escalas';

  @override
  String get romanModeNumeralToChord => 'Grau → Acorde';

  @override
  String get romanModeChordToNumeral => 'Acorde → Grau';

  @override
  String get romanWhichChord => 'Que acorde é este grau?';

  @override
  String get romanWhichDegree => 'Que grau é este acorde?';

  @override
  String get romanSevenths => 'Acordes de sétima';

  @override
  String get romanSeventhsHelpTitle => 'Acordes de Sétima';

  @override
  String get romanSeventhsHelpBody =>
      'Quando ativado, os graus ganham mais uma terça empilhada, então o quinto grau de um tom maior é V7 e não V. São os mesmos sete graus, nomeados com mais precisão.';

  @override
  String get romanHearChord => 'Ouvir o acorde';

  @override
  String get romanHearChordHelpTitle => 'Ouvir o Acorde';

  @override
  String get romanHearChordHelpBody =>
      'Quando ativado, o acorde toca assim que a resposta é revelada. Nomear um grau é exercício de papel enquanto você não ouve como ele soa.';
}
