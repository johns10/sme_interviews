import { v4 } from 'uuid';

const SAMPLE_RATE = 16000
const CHANNEL_COUNT = 1

class SpeechEvent {
  constructor({ stream, audioContext, hooks }) {
    this.stream = stream
    this.audioContext = audioContext
    this.recorder = this.startRecorder(audioContext, stream)
    this.chunk = new Blob()
    this.hooks = hooks
    this.id = v4()
    this.status = 'pending'
    this.file = null
    this.url = null
    this.from = null
    this.to = null
    this.text = null
    this.confidence = null
  }

  fields() {
    return {
      id: this.id,
      from: this.from,
      to: this.to,
      text: this.text,
      confidence: this.confidence
    }
  }

  start() {
    console.log(`${this.id} utterance started`)
    this.status = 'started'
    this.from = Math.floor(Date.now() / 1000)
  }

  startRecorder(audioContext, stream) {
    const { mediaStream } = audioContext.createMediaStreamSource(stream)
    const recorder = new MediaRecorder(mediaStream, {
      audioBitsPerSecond: SAMPLE_RATE,
      channelCount: CHANNEL_COUNT
    })
    recorder.ondataavailable = event => this.handleRecordedAudio(event)
    recorder.start()
    return recorder
  }

  enableBuffer() {
    setTimeout(() => {
      if (this.status != 'started') {
        console.log('ping')
        this.recorder.requestData()
      }
      this.enableBuffer()
    }, 1000)
  }

  end() {
    console.log('utterance ended')
    this.status = 'ended'
    this.to = Math.floor(Date.now() / 1000)
    this.recorder.stop()
  }

  handleRecordedAudio(event) {
    console.log(this.status)
    if (this.status == 'ended') this.storeRecordedAudio(event)
    else if (this.status == 'pending') this.chunk = event.data
  }

  async storeRecordedAudio(event) {
    console.log('storing recorded audio')
    const blob = new Blob([this.chunk, event.data], { 'type': 'audio/wav; codecs=0' });

    const audioContext = new AudioContext()
    const source = audioContext.createBufferSource()
    const dest = audioContext.createMediaStreamDestination()
    const mediaRecorder = new MediaRecorder(dest.stream)
    const audioData = await blob.arrayBuffer()
    const buffer = await audioContext.decodeAudioData(audioData)
    source.buffer = buffer
    source.connect(dest)
    mediaRecorder.ondataavailable = event => console.log('here')
    mediaRecorder.start()
    source.start(audioContext.currentTime, 1)
    source.stop()

    this.file = new File([blob], `${this.id}.wav`, { type: blob.type })
    this.maybePushEvent()
  }

  transcribe({ results }) {
    console.log('transcribing audio')
    this.to = Math.floor(Date.now() / 1000)
    if (results[0][0]) this.text = results[0][0].transcript
    if (results[0][0]) this.confidence = results[0][0].confidence
    this.maybePushEvent()
  }

  maybePushEvent() {
    console.log('will push: ', !!this.file, !!this.text)
    if (this.file && this.text) {
      this.hooks.pushEvent("utterance-transcribed", this.fields(), reply => {
        fetch(reply.url, { method: 'put', body: this.file })
          .then(() => {
            this.hooks.pushEvent("utterance-uploaded", { id: this.id });
            console.groupEnd()
          })
      })
    }
  }

  kill() {
    this.recorder.stop()
    delete (this.recorder)
  }
}

export default SpeechEvent