import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/chord_playback_service.dart';
import '../../../core/harmony/data/voicing.dart';
import '../../../core/harmony/domain/diatonic_chord.dart';
import '../data/roman_questions.dart';
import '../domain/roman_question.dart';
import '../domain/roman_session_state.dart';

final _chordPlaybackProvider = Provider<ChordPlaybackService>((ref) {
  final service = ChordPlaybackService();
  ref.onDispose(service.dispose);
  return service;
});

/// Drives the roman numeral drill: a question, an answer, the running score.
///
/// Nothing here listens to the microphone. The question is a naming one, so
/// the answer is a tap and the chord is only played back once it is revealed.
class RomanTrainingNotifier extends Notifier<RomanSessionState> {
  final _random = Random();
  RomanDrillConfig? _config;

  @override
  RomanSessionState build() => const RomanSessionState();

  Future<void> start(RomanDrillConfig config) async {
    _config = config;
    state = const RomanSessionState();
    if (config.hearChord) await ref.read(_chordPlaybackProvider).init();
    _nextQuestion(null);
  }

  void submitAnswer(DiatonicChord answer) {
    final question = state.question;
    if (question == null || state.phase != RomanPhase.waitingForAnswer) return;

    final isCorrect = answer == question.answer;
    state = state.copyWith(
      phase: RomanPhase.showingResult,
      answered: answer,
      isCorrect: isCorrect,
      correctCount: state.correctCount + (isCorrect ? 1 : 0),
      totalCount: state.totalCount + 1,
      streak: isCorrect ? state.streak + 1 : 0,
    );

    if (_config?.hearChord ?? false) {
      unawaited(ref
          .read(_chordPlaybackProvider)
          .playChord(voiceChord(question.answer), arpeggiate: true));
    }
  }

  void nextQuestion() {
    if (state.phase != RomanPhase.showingResult) return;
    _nextQuestion(state.question);
  }

  Future<void> stop() async {
    await ref.read(_chordPlaybackProvider).stop();
    state = const RomanSessionState();
  }

  void _nextQuestion(RomanQuestion? previous) {
    final config = _config;
    if (config == null) return;
    state = state.copyWith(
      phase: RomanPhase.waitingForAnswer,
      question: buildRomanQuestion(config, _random, previous: previous),
      answered: null,
      isCorrect: null,
    );
  }
}

final romanTrainingProvider =
    NotifierProvider<RomanTrainingNotifier, RomanSessionState>(
  RomanTrainingNotifier.new,
);
