import 'dart:math';
import 'dart:typed_data';
import 'dart:web_audio';

import 'package:opus_dart/opus_dart.dart';

import '../abstract/player.dart';

const sampleRate = 48000;
const channels = 2;

class WebAudioPlayer implements Player {
  
  late final BufferedOpusDecoder _decoder;
  late final AudioContext _audioContext;
  late final GainNode _volumeNode;

  void init() {
    _decoder = BufferedOpusDecoder(sampleRate: sampleRate, channels: channels);
    _audioContext = AudioContext();
    _volumeNode = _audioContext.createGain();

    _volumeNode.connectNode(_audioContext.destination!);
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

    _frameTime = max(
        _frameTime + frameDuration,
        _audioContext.getOutputTimestamp()['contextTime']
    );
  }

  @override
  void dispose() {
    _audioContext.close();
    _decoder.destroy();
  }
}
