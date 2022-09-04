import { v4 } from 'uuid';
import Database from '../lib/database'
import { assignFile, putAudio } from '../lib/utterances'
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
    this.audio = null
    this.url = null
  }

  fields() {
    return {
      id: this.id,
      status: this.status
    }
  }

  start() {
    this.status = 'started'
    this.hooks.pushEvent("utterance-started", this.fields())
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
    this.status = 'ended'
    this.recorder.stop()
  }

  handleRecordedAudio(event) {
    if (this.status == 'ended') this.storeRecordedAudio(event)
    else if (this.status == 'started') this.chunk = event.data
  }

  storeRecordedAudio(event) {
    const blob = new Blob([this.chunk, event.data], { 'type': 'audio/wav; codecs=0' });
    const file = new File([blob], `${this.id}.wav`, { type: blob.type })
    this.hooks.pushEvent("utterance-ended", { id: this.id }, (reply) => {
      fetch(reply.url, { method: 'put', body: file })
        .then(() => this.hooks.pushEvent("utterance-uploaded", { id: this.id }))
    })
  }

  transcribe({ results }) {
    this.hooks.pushEvent("utterance-updated", {
      id: this.id,
      status: "interim_transcription",
      text: results[0][0].transcript,
      confidence: results[0][0].confidence
    })
  }
}

class Recorder {
  constructor({ hooks }) {
    this.hooks = hooks
    this.chunk = new Blob()
    this.audioContext = null
    this.stream = null
    this.vad = null
    this.speechEvent = null
    this.pastEvents = []
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

const VoiceDetector = {
  mounted() {
    recorder = new Recorder({ hooks: this })
    recorder.initialize()
  }
};

export default VoiceDetector;
