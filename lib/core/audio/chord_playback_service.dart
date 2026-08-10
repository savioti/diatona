import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../harmony/data/voicing.dart';
import 'piano_sample.dart';

/// Plays chords, and runs of them, on the piano samples.
///
/// One player per voice, reused from chord to chord. A player is stopped before
/// it is given the next note: without that, repeated plays layer on top of each
/// other and the players fall into an error state after a while, the same
/// problem the interval playback service ran into.
class ChordPlaybackService {
  /// How long a note of an arpeggiated chord waits for the one before it.
  static const int strumMillis = 110;

  /// How long the last chord of a run is left ringing before the listener is
  /// asked to answer.
  static const int tailMillis = 500;

  final List<AudioPlayer> _players = [];
  final List<Timer> _noteTimers = [];
  Timer? _chordTimer;
  Timer? _tailTimer;
  bool _initialized = false;

  /// Bumped by [stop], so that a play still waiting on an await does not put a
  /// note out after the run it belongs to was cancelled.
  int _generation = 0;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Started before the players so the copying runs alongside their setup.
    final warmed = warmPianoSamples();

    final created = <AudioPlayer>[];
    for (var i = 0; i < kVoiceCount; i++) {
      final player = AudioPlayer();
      player.eventStream.listen((_) {}, onError: (_) {});
      await player.setPlayerMode(PlayerMode.lowLatency);
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setVolume(1.0);
      created.add(player);
    }

    await warmed;

    // A screen can be left while the players are still being set up, and
    // [dispose] clears the flag. Whatever was built by then is ours to throw
    // away, it never reached [_players].
    if (!_initialized) {
      for (final player in created) {
        unawaited(player.dispose());
      }
      return;
    }
    _players.addAll(created);
  }

  /// Plays one chord and nothing else.
  Future<void> playChord(List<int> midiNotes, {bool arpeggiate = false}) async {
    if (_players.isEmpty) return;
    _cancelTimers();
    await _strike(midiNotes, arpeggiate, ++_generation);
  }

  /// Plays [chords] one after another, [millisPerChord] apart, and calls
  /// [onComplete] once the last one has had time to ring.
  ///
  /// [onChord] fires as each chord starts, which is what lets a screen follow
  /// along with what is sounding.
  Future<void> playSequence(
    List<List<int>> chords, {
    required int millisPerChord,
    bool arpeggiate = false,
    void Function(int index)? onChord,
    void Function()? onComplete,
  }) async {
    if (_players.isEmpty || chords.isEmpty) {
      onComplete?.call();
      return;
    }
    _cancelTimers();
    final generation = ++_generation;

    var index = 0;
    onChord?.call(index);
    await _strike(chords[index++], arpeggiate, generation);

    _chordTimer = Timer.periodic(
      Duration(milliseconds: millisPerChord),
      (timer) {
        if (generation != _generation) {
          timer.cancel();
          return;
        }
        if (index >= chords.length) {
          timer.cancel();
          _chordTimer = null;
          _tailTimer = Timer(
            const Duration(milliseconds: tailMillis),
            () {
              if (generation == _generation) onComplete?.call();
            },
          );
          return;
        }
        onChord?.call(index);
        unawaited(_strike(chords[index++], arpeggiate, generation));
      },
    );
  }

  Future<void> stop() async {
    _generation++;
    _cancelTimers();
    await Future.wait([for (final player in _players) player.stop()]);
  }

  Future<void> dispose() async {
    _generation++;
    _cancelTimers();
    _initialized = false;
    await Future.wait([for (final player in _players) player.dispose()]);
    _players.clear();
  }

  Future<void> _strike(
    List<int> midiNotes,
    bool arpeggiate,
    int generation,
  ) async {
    await Future.wait([for (final player in _players) player.stop()]);
    if (generation != _generation) return;

    final notes = midiNotes.take(_players.length).toList();
    for (var i = 0; i < notes.length; i++) {
      final source = AssetSource(pianoAssetPath(
        notes[i].clamp(kPianoMidiMin, kPianoMidiMax),
      ));
      if (!arpeggiate) {
        unawaited(_players[i].play(source));
        continue;
      }
      final player = _players[i];
      _noteTimers.add(Timer(
        Duration(milliseconds: strumMillis * i),
        () {
          if (generation == _generation) unawaited(player.play(source));
        },
      ));
    }
  }

  void _cancelTimers() {
    _chordTimer?.cancel();
    _chordTimer = null;
    _tailTimer?.cancel();
    _tailTimer = null;
    for (final timer in _noteTimers) {
      timer.cancel();
    }
    _noteTimers.clear();
  }
}
