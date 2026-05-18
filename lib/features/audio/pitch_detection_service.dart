import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:record/record.dart';

class PitchDetectionService {
  static const int _sampleRate = 22050;
  static const int _bufferSize = 2048;

  final _recorder = AudioRecorder();
  final _noteController = StreamController<String>.broadcast();
  final _detector = PitchDetector(
    audioSampleRate: 22050.0,
    bufferSize: _bufferSize,
  );

  StreamSubscription<Uint8List>? _sub;
  List<int> _byteBuffer = [];
  bool _processing = false;

  Stream<String> get notes => _noteController.stream;

  Future<void> start() async {
    if (!await _recorder.hasPermission()) return;
    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: _sampleRate,
        numChannels: 1,
      ),
    );
    _byteBuffer = [];
    _sub = stream.listen(_onBytes);
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
    _byteBuffer = [];
    if (await _recorder.isRecording()) await _recorder.stop();
  }

  Future<void> dispose() async {
    await stop();
    if (!_noteController.isClosed) await _noteController.close();
    await _recorder.dispose();
  }

  void _onBytes(Uint8List bytes) {
    _byteBuffer.addAll(bytes);
    if (_processing || _byteBuffer.length < _bufferSize * 2) return;

    // Take one buffer's worth and discard the rest to stay real-time.
    final chunk = Uint8List.fromList(_byteBuffer.sublist(0, _bufferSize * 2));
    _byteBuffer = [];
    unawaited(_analyze(chunk));
  }

  Future<void> _analyze(Uint8List chunk) async {
    _processing = true;
    try {
      final result = await _detector.getPitchFromIntBuffer(chunk);
      if (result.pitched && !_noteController.isClosed) {
        final note = _noteFromHz(result.pitch);
        if (note != null) _noteController.add(note);
      }
    } finally {
      _processing = false;
    }
  }

  static String? _noteFromHz(double hz) {
    if (hz <= 0) return null;
    const names = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final midi = (12 * log(hz / 440.0) / log(2) + 69).round();
    final index = midi % 12;
    return index >= 0 ? names[index] : null;
  }
}
