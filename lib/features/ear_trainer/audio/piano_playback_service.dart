import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../../../core/audio/piano_sample.dart';
import '../domain/ear_training_question.dart';
import '../domain/interval_direction.dart';

class PianoPlaybackService {
  // MIDI range covered by the piano samples.
  static const int midiMin = kPianoMidiMin;
  static const int midiMax = kPianoMidiMax;

  AudioPlayer? _player1;
  AudioPlayer? _player2;
  bool _initialized = false;
  Timer? _sequenceTimer;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Started before the players so the copying runs alongside their setup.
    final warmed = warmPianoSamples();

    _player1 = AudioPlayer();
    _player2 = AudioPlayer();
    for (final p in [_player1!, _player2!]) {
      p.eventStream.listen((_) {}, onError: (_) {});
      await p.setPlayerMode(PlayerMode.lowLatency);
      await p.setReleaseMode(ReleaseMode.stop);
      await p.setVolume(1.0);
    }

    await warmed;
  }

  /// Plays [question] and calls [onComplete] once the listener should answer.
  Future<void> play(
    EarTrainingQuestion question, {
    void Function()? onComplete,
  }) async {
    if (_player1 == null || _player2 == null) return;
    _sequenceTimer?.cancel();

    // Stop both players before each play. Without this, repeated play() calls
    // layer audio streams (volume appears to drop each time) and players
    // enter error states after several questions, causing the second note
    // to silently fail.
    await Future.wait([_player1!.stop(), _player2!.stop()]);

    final firstPath = _assetPath(question.firstMidi);
    final secondPath = _assetPath(question.secondMidi);

    if (question.direction == IntervalDirection.harmonic) {
      await Future.wait([
        _player1!.play(AssetSource(firstPath)),
        _player2!.play(AssetSource(secondPath)),
      ]);
      _sequenceTimer = Timer(
        const Duration(milliseconds: 1800),
        () => onComplete?.call(),
      );
    } else {
      await _player1!.play(AssetSource(firstPath));
      _sequenceTimer = Timer(const Duration(milliseconds: 1200), () async {
        // Await the second note so that the 1 s onComplete delay only starts
        // once the note has actually begun playing.
        await _player2!.play(AssetSource(secondPath));
        _sequenceTimer = Timer(
          const Duration(milliseconds: 1000),
          () => onComplete?.call(),
        );
      });
    }
  }

  Future<void> stop() async {
    _sequenceTimer?.cancel();
    _sequenceTimer = null;
    await _player1?.stop();
    await _player2?.stop();
  }

  Future<void> dispose() async {
    _sequenceTimer?.cancel();
    _sequenceTimer = null;
    _initialized = false;
    await _player1?.dispose();
    await _player2?.dispose();
    _player1 = null;
    _player2 = null;
  }

  /// Returns the human-readable note name for a MIDI number, e.g. "C4", "Db5".
  static String midiToNoteName(int midi) => pianoNoteName(midi);

  /// Converts a MIDI number (48-83) to the asset path used by audioplayers.
  static String _assetPath(int midi) => pianoAssetPath(midi);
}
