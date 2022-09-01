import { fetchFile } from '../lib/utils'
import Database from '../lib/database'
import { shiftBuffer, assignFile, newSpeechEvent, putAudio } from '../lib/utterances'
database = new Database();
const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition

class Recorder {
  constructor({ hooks }) {
    this.chunk = new Blob()
    this.stream = null
    this.recognize = null
    this.speechEvent = null
    this.hooks = hooks
    this.recorderOpts = {
      audioBitsPerSecond: 16000,
      channelCount: 1
    }
  }

  async initialize() {
    navigator
      .mediaDevices
      .getUserMedia({ audio: true, video: false })
      .then(stream => {
        this.stream = stream
        this.startRecognize()
        this.startRecorder()
        this.enableBuffer()
      })
  }

  startUtterance() {
    this.speechEvent = newSpeechEvent()
    this.hooks.pushEvent("utterance-started", this.speechEvent)
  }

  endUtterance() {
    this.speechEvent.status = 'ended'
    this.recorder.requestData()
  }

  handleRecordedAudio(event) {
    if (this.speechEvent) this.storeRecordedAudio(event)
    else this.chunk = event.data
  }

  storeRecordedAudio(event) {
    const chunks = [this.chunk, event.data]
    const { id } = this.speechEvent
    const file = assignFile({ chunks, speechEvent: this.speechEvent })
    this.hooks.pushEvent("utterance-ended", { id }, (reply) => {
      putAudio({ url: reply.url, file })
        .then(() => this.hooks.pushEvent("utterance-uploaded", { id }))
      this.speechEvent = null
      this.stopRecognize()
      this.stopRecorder()
      this.startRecorder()
      this.startRecognize()
    })
  }

  enableBuffer() {
    setTimeout(() => {
      if (this.speechEvent?.status != 'started') {
        this.recorder.requestData()
      }
      this.enableBuffer()
    }, 1000)
  }

  startRecorder() {
    this.recorder = new MediaRecorder(this.stream, this.recorderOpts)
    this.recorder.addEventListener("dataavailable", event => this.handleRecordedAudio(event));
    this.recorder.start()
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

const Transcriber = {
  mounted() {
    recorder = new Recorder({ hooks: this })
    recorder.initialize()
  }
};

export default Transcriber;
