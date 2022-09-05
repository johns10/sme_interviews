import { v4 } from 'uuid';
import Database from '../lib/database'
import Alpine from 'alpinejs';
database = new Database();
const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition

class SpeechEvent {
  constructor({ stream, audioContext, hooks }) {
    this.stream = stream
    this.audioContext = audioContext
    this.recorder = this.startRecorder(audioContext, stream)
    this.chunk = new Blob()
    this.hooks = hooks
    this.id = v4()
    this.status = null
    this.file = null
    this.url = null
    this.from = null
    this.to = null
  }

  fields() {
    return {
      id: this.id,
      status: this.status,
      from: this.from,
      to: this.to
    }
  }

  start() {
    console.group([this.id])
    console.log('utterance started')
    this.status = 'started'
    Alpine.store('recorder').startSpeaking()
    this.from = Math.floor(Date.now() / 1000)
  }

  startRecorder(audioContext, stream) {
    const { mediaStream } = audioContext.createMediaStreamSource(stream)
    recorder = new MediaRecorder(mediaStream, {
      audioBitsPerSecond: 16000,
      channelCount: 1
    })
    recorder.ondataavailable = event => this.handleRecordedAudio(event)
    recorder.start()
    return recorder
  }

  end() {
    console.log('utterance ended')
    this.status = 'ended'
    this.to = Math.floor(Date.now() / 1000)
    Alpine.store('recorder').stopSpeaking()
    this.recorder.stop()
  }

  handleRecordedAudio(event) {
    if (this.status == 'ended') this.storeRecordedAudio(event)
    else if (this.status == 'started') this.chunk = event.data
  }

  storeRecordedAudio(event) {
    console.log('storing recorded audio')
    const blob = new Blob([this.chunk, event.data], { 'type': 'audio/wav; codecs=0' });
    this.file = new File([blob], `${this.id}.wav`, { type: blob.type })
  }

  transcribe({ results }) {
    console.log('transcribing audio')
    this.to = Math.floor(Date.now() / 1000)
    if (results[0][0]) {
      this.hooks.pushEvent("utterance-transcribed", {
        text: results[0][0].transcript,
        confidence: results[0][0].confidence,
        ...this.fields()
      }, reply => fetch(reply.url, { method: 'put', body: this.file })
        .then(() => this.hooks.pushEvent("utterance-uploaded", { id: this.id }))
      )
    }
    console.groupEnd()
  }

  kill() {
    this.recorder.stop()
    delete (this.recorder)
  }
}

class Recorder {
  constructor({ hooks }) {
    this.hooks = hooks
    this.chunk = new Blob()
    this.audioContext = null
    this.stream = null
    this.speechEvent = null
  }

  initialize() {
    navigator
      .mediaDevices
      .getUserMedia({ audio: true, video: false })
      .then(stream => {
        this.audioContext = new AudioContext()
        this.stream = stream
        this.speechEvent = this.newSpeechEvent()
        this.startRecognize()
      })
  }

  restart() {
    this.recognize.stop()
    this.recognize = null
    this.speechEvent = null
    this.speechEvent = this.newSpeechEvent()
    this.startRecognize()
  }

  stop() {
    this.speechEvent.kill()
    this.stopRecognize()
    this.speechEvent = null
  }

  startRecognize() {
    this.recognize = new SpeechRecognition()
    this.recognize.lang = 'en-US'
    this.recognize.continuous = false
    this.recognize.onspeechstart = () => this.speechEvent.start()
    this.recognize.onspeechend = () => {
      this.speechEvent.end()
      this.restart()
    }
    this.recognize.onresult = this.transcribeSpeechEvent()
    this.recognize.start()
  }

  stopRecognize() {
    this.recognize = null
  }

  newSpeechEvent() {
    return new SpeechEvent({
      stream: this.stream,
      audioContext: this.audioContext,
      hooks: this.hooks
    })
  }

  transcribeSpeechEvent() {
    const speechEvent = this.speechEvent
    return event => speechEvent.transcribe(event)
  }

  enableBuffer() {
    setTimeout(() => {
      if (this.speechEvent?.status != 'started') {
        this.recorder.requestData()
        this.startRecognize()
      }
      this.enableBuffer()
    }, 1000)
  }
}

Alpine.store('recorder', {
  on: false,
  speaking: false,
  turnOn() { this.on = true },
  turnOff() { this.on = false },
  startSpeaking() { this.speaking = true },
  stopSpeaking() { this.speaking = false }
})

Alpine.start()

const VoiceDetector = {
  mounted() {
    recorderManager = new Recorder({ hooks: this })
    this.el.addEventListener("click", () => {
      if (recorderManager.speechEvent) {
        recorderManager.stop()
        Alpine.store('recorder').turnOff()
      } else {
        recorderManager.initialize()
        Alpine.store('recorder').turnOn()
      }
    })
  }
};

export default VoiceDetector;
