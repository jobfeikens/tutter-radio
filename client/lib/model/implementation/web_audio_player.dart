import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';
import 'dart:web_audio';

import 'package:opus_dart/opus_dart.dart';
import 'package:tutter_radio/common/audio_effect.dart';

import '../abstract/player.dart';

const sampleRate = 48000;
const channels = 2;

class WebAudioPlayer implements Player {
  
  late final BufferedOpusDecoder _decoder;
  late final AudioContext _audioContext;
  late final GainNode _volumeNode;

  double get _contextTime =>
      _audioContext.currentTime!.toDouble();

  void init() {
    _decoder = BufferedOpusDecoder(sampleRate: sampleRate, channels: channels);
    _audioContext = AudioContext();
    _audioContext.resume();

    _volumeNode = _audioContext.createGain()
      ..connectNode(_audioContext.destination!);
  }

  @override
  void setVolume(double volume) {
    // To perceived loudness
    _volumeNode.gain!.value = (pow(20, volume) - 1) / (20 - 1);
  }

  @override
  void pauseResume(bool paused) {
    if (paused) {
      _audioContext.suspend();
    } else {
      _audioContext.resume();
    }
  }

  // Each channel holds at most 48000 Hz * 60 ms = 2880 samples
  final leftBuffer = Float32List(2880);
  final rightBuffer = Float32List(2880);

  double _frameTime = 0;

  int i = 0;

  @override
  void playFrame(List<int> encodedData) {
    _decoder.inputBuffer.setAll(0, encodedData);
    _decoder.inputBufferIndex = encodedData.length;

    final decodedData = _decoder.decodeFloat();
    final bufferSize = decodedData.length ~/ channels;
    final frameDuration = bufferSize / sampleRate;

    // De-interlace frame
    for (var sample = 0; sample < bufferSize; sample++) {
      leftBuffer[sample] = decodedData[sample * channels];
      rightBuffer[sample] = decodedData[sample * channels + 1];
    }
    final buffer = _audioContext.createBuffer(channels, bufferSize, sampleRate);

    buffer.copyToChannel(leftBuffer, 0);
    buffer.copyToChannel(rightBuffer, 1);

    final bufferSource = _audioContext.createBufferSource();
    bufferSource.buffer = buffer;

    bufferSource.connectNode(_volumeNode);
    bufferSource.start(_frameTime);

    _frameTime = max<double>(
        _frameTime + frameDuration,
        _contextTime,
    );

    // Round frame time to nearest tenth of a millisecond (4 decimal places)
    _frameTime = double.parse(_frameTime.toStringAsFixed(4));
  }

  @override
  void dispose() {
    _audioContext.close();
    _decoder.destroy();
  }

  static Float32List createDistortionCurve([int k = 300]) {
    final curve = Float32List(2880);

    for (int i = 0; i < curve.length; i++) {
      final x = i * 2 / curve.length - 1;
      curve[i] = (pi + k) * x / (pi + k * x.abs());
    }
    return curve;
  }
}
