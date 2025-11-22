import { OpusDecoder, OpusDecoderWebWorker } from "opus-decoder";
import { pow, max, number } from "mathjs";
import { BehaviorSubject, distinct } from "rxjs";


export async function init_player() {
  const decoder = new OpusDecoder();
  await decoder.ready;
  return new Player(decoder);
}

export class Player {
  constructor(decoder) {
    this.decoder = decoder;
    this.audioContext = new AudioContext();

    this.volumeNode = this.audioContext.createGain();
    this.volumeNode.connect(this.audioContext.destination);

    this.currentSong = new BehaviorSubject(undefined);
    this.frameTime = 0;
  }

  setVolume(volume) {
    this.volumeNode.gain.value = (pow(20, volume) - 1) / (20 - 1);
  }

  getCurrentSong() {
    return this.currentSong.pipe(distinct());
  }

  pauseResume(paused) {
    if (paused) {
      this.audioContext.suspend();
    } else {
      this.audioContext.resume();
    }
  }

  async playFrame(encodedData, songId) {
    const { channelData, samplesDecoded, sampleRate } =
      this.decoder.decodeFrame(encodedData);

    const buffer = this.audioContext.createBuffer(
      channelData.length,
      samplesDecoded,
      sampleRate,
    );

    for (let channel = 0; channel < channelData.length; channel++) {
      buffer.copyToChannel(channelData[channel], channel);
    }

    const bufferSource = this.audioContext.createBufferSource();
    bufferSource.buffer = buffer;

    bufferSource.connect(this.volumeNode);
    bufferSource.start(this.frameTime);

    bufferSource.onended = () => this.currentSong.next(songId);

    this.frameTime = max(
      this.frameTime + samplesDecoded / sampleRate,
      this.audioContext.currentTime,
    );
  }

  async close() {
    await this.audioContext.close();
    await this.decoder.free();
  }
}
