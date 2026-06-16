import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../domain/ear_training_question.dart';
import '../domain/interval_direction.dart';

class PianoPlaybackService {
  // Flat-notation names matching the asset filenames.
  static const _noteNames = [
    'C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B',
  ];

  // MIDI range covered by the piano samples.
  static const int midiMin = 48; // C3
  static const int midiMax = 83; // B5

  AudioPlayer? _player1;
  AudioPlayer? _player2;
  bool _initialized = false;
  Timer? _sequenceTimer;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    _player1 = AudioPlayer();
    _player2 = AudioPlayer();
    for (final p in [_player1!, _player2!]) {
      p.eventStream.listen((_) {}, onError: (_) {});
      await p.setPlayerMode(PlayerMode.lowLatency);
      await p.setReleaseMode(ReleaseMode.stop);
      await p.setVolume(1.0);
    }
  }

  /// Plays [question] and calls [onComplete] once the listener should answer.
  Future<void> play(
    EarTrainingQuestion question, {
    void Function()? onComplete,
  }) async {
    if (_player1 == null || _player2 == null) return;
    _sequenceTimer?.cancel();

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
      _sequenceTimer = Timer(const Duration(milliseconds: 1200), () {
        unawaited(_player2!.play(AssetSource(secondPath)));
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

  /// Converts a MIDI number (48–83) to the asset path used by audioplayers.
  static String _assetPath(int midi) {
    final semitone = midi % 12;
    final octave = midi ~/ 12 - 1;
    final name = _noteNames[semitone];
    return 'instrument_sounds/piano/piano_mf_$name$octave.mp3';
  }
}
