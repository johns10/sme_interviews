import vad from '../lib/vad';
import Database from '../lib/database'
import { assignFile, newSpeechEvent, putAudio } from '../lib/utterances'
database = new Database();
const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition

class Recorder {
  constructor({ hooks }) {
    this.hooks = hooks
    this.chunk = new Blob()
    this.audioContext = null
    this.stream = null
    this.vad = null
    this.speechEvent = null
  }

  initialize() {
    navigator
      .mediaDevices
      .getUserMedia({ audio: true, video: false })
      .then(stream => {
        this.audioContext = new AudioContext()
        this.stream = stream
        this.startRecognizer()
        this.startRecorder()
      })
  }

  startRecognizer() {
    const vadSource = this.audioContext.createMediaStreamSource(this.stream)
    this.vad = new vad({
      voice_start: () => this.startUtterance(),
      voice_stop: () => this.stopUtterance(),
      source: vadSource
    })
  }

  startRecorder() {
    const { mediaStream } = this.audioContext.createMediaStreamSource(this.stream)
    this.recorder = new MediaRecorder(mediaStream, {
      audioBitsPerSecond: 16000,
      channelCount: 1
    })
    this.recorder.addEventListener("dataavailable", event => this.handleRecordedAudio(event));
    this.recorder.start()
  }

  startUtterance() {
    console.log('starting utterance')
    this.speechEvent = newSpeechEvent()
    this.hooks.pushEvent("utterance-started", this.speechEvent)
  }

  stopUtterance() {
    console.log('ending utterance')
    this.speechEvent.status = 'ended'
    this.recorder.requestData()
  }

  handleRecordedAudio(event) {
    if (this.speechEvent) this.storeRecordedAudio(event)
    else this.chunk = event.data
  }

  storeRecordedAudio(event) {
    console.log('storing recorded audio')
    const chunks = [this.chunk, event.data]
    const { id } = this.speechEvent
    const file = assignFile({ chunks, speechEvent: this.speechEvent })
    this.hooks.pushEvent("utterance-ended", { id }, (reply) => {
      putAudio({ url: reply.url, file })
        .then(() => this.hooks.pushEvent("utterance-uploaded", { id }))
      this.speechEvent = null
      this.stopRecorder()
      this.startRecorder()
    })
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

  stopRecorder() {
    this.recorder = null
  }

  startRecognize() {
    this.recognize = new SpeechRecognition()
    this.recognize.lang = 'en-US'
    this.recognize.onspeechstart = () => this.startUtterance()
    this.recognize.onspeechend = () => this.endUtterance()
    this.recognize.start()
  }

  stopRecognize() {
    this.recognize = null
  }
}

const VoiceDetector = {
  mounted() {
    recorder = new Recorder({ hooks: this })
    recorder.initialize()
  }
};

export default VoiceDetector;
