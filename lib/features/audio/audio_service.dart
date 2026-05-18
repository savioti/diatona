import 'package:audioplayers/audioplayers.dart';

import '../trainer/domain/chord.dart';

class AudioService {
  AudioPlayer? _successPlayer;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    _successPlayer = AudioPlayer();
    _successPlayer!.eventStream.listen((_) {}, onError: (_) {});
    await _successPlayer!.setPlayerMode(PlayerMode.lowLatency);
    await _successPlayer!.setReleaseMode(ReleaseMode.stop);
    await _successPlayer!.setSource(AssetSource('success.wav'));
    await _successPlayer!.setVolume(1.0);
  }

  Future<void> playSuccess() async {
    if (_successPlayer == null) return;
    try {
      await _successPlayer!.stop();
      await _successPlayer!.resume();
    } catch (_) {}
  }

  /// Stub — plays chord audio when assets are available.
  Future<void> playChord(Chord chord) async {
    if (chord.soundAssetPath == null) return;
    // TODO: implement chord audio playback
  }

  Future<void> dispose() async {
    _initialized = false;
    await _successPlayer?.dispose();
    _successPlayer = null;
  }
}
