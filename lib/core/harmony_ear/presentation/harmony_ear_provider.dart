import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audio/chord_playback_service.dart';
import '../../harmony/data/voicing.dart';
import '../domain/harmony_ear_question.dart';
import '../domain/harmony_ear_session_state.dart';

final _chordPlaybackProvider = Provider<ChordPlaybackService>((ref) {
  final service = ChordPlaybackService();
  ref.onDispose(service.dispose);
  return service;
});

/// Everything a listening round needs that is not the engine itself.
///
/// [nextQuestion] is handed the question just asked, so a trainer can avoid
/// putting the same one up twice in a row.
@immutable
class HarmonyEarConfig {
  const HarmonyEarConfig({
    required this.choices,
    required this.nextQuestion,
    required this.millisPerChord,
    this.arpeggiate = false,
  });

  final List<HarmonyEarChoice> choices;
  final HarmonyEarQuestion Function(HarmonyEarQuestion? previous) nextQuestion;
  final int millisPerChord;
  final bool arpeggiate;
}

/// Plays a run of chords and asks what it was.
///
/// The progression and cadence trainers are the same round over different
/// questions, so they run on this and only differ in what they put in the
/// [HarmonyEarConfig].
class HarmonyEarNotifier extends Notifier<HarmonyEarSessionState> {
  HarmonyEarConfig? _config;

  /// Cleared by [stop]. A start waiting on the samples to load checks this
  /// before it plays, so leaving the screen during the load does not open a
  /// round no one is on.
  bool _running = false;

  @override
  HarmonyEarSessionState build() {
    // Held rather than read back later: ref is gone by the time this runs.
    final piano = ref.read(_chordPlaybackProvider);
    ref.onDispose(() => unawaited(piano.stop()));
    return const HarmonyEarSessionState();
  }

  ChordPlaybackService get _piano => ref.read(_chordPlaybackProvider);

  Future<void> start(HarmonyEarConfig config) async {
    _config = config;
    _running = true;
    state = HarmonyEarSessionState(choices: config.choices);
    await _piano.init();
    if (!_running) return;
    _askNext(null);
  }

  void replay() {
    final question = state.question;
    if (question == null) return;
    state = state.copyWith(phase: HarmonyEarPhase.playing);
    _play(question);
  }

  void submitAnswer(HarmonyEarChoice choice) {
    final question = state.question;
    if (question == null ||
        state.phase != HarmonyEarPhase.waitingForAnswer) {
      return;
    }

    final isCorrect = choice.id == question.choiceId;
    state = state.copyWith(
      phase: HarmonyEarPhase.showingResult,
      answeredId: choice.id,
      isCorrect: isCorrect,
      correctCount: state.correctCount + (isCorrect ? 1 : 0),
      totalCount: state.totalCount + 1,
      streak: isCorrect ? state.streak + 1 : 0,
    );
  }

  void nextQuestion() {
    if (state.phase != HarmonyEarPhase.showingResult) return;
    _askNext(state.question);
  }

  Future<void> stop() async {
    _running = false;
    await _piano.stop();
    state = const HarmonyEarSessionState();
  }

  void _askNext(HarmonyEarQuestion? previous) {
    final config = _config;
    if (config == null) return;
    final question = config.nextQuestion(previous);
    state = state.copyWith(
      phase: HarmonyEarPhase.playing,
      question: question,
      answeredId: null,
      isCorrect: null,
    );
    _play(question);
  }

  void _play(HarmonyEarQuestion question) {
    final config = _config;
    if (config == null) return;
    unawaited(_piano.playSequence(
      voiceProgression(question.chords),
      millisPerChord: config.millisPerChord,
      arpeggiate: config.arpeggiate,
      onComplete: () {
        if (state.phase == HarmonyEarPhase.playing) {
          state = state.copyWith(phase: HarmonyEarPhase.waitingForAnswer);
        }
      },
    ));
  }
}

final harmonyEarProvider =
    NotifierProvider<HarmonyEarNotifier, HarmonyEarSessionState>(
  HarmonyEarNotifier.new,
);
