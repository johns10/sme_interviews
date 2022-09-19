import SpeechEvent from "./speechEvent"
const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition

class Recorder {
  constructor({ hooks, onspeechstart, onspeechend }) {
    this.hooks = hooks
    this.audioContext = null
    this.stream = null
    this.speechEvent = null
    this.onspeechstart = onspeechstart
    this.onspeechend = onspeechend
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
    this.recognize.onspeechstart = () => {
      this.speechEvent.start()
      this.onspeechstart()
    }
    this.recognize.onspeechend = () => {
      this.speechEvent.end()
      this.onspeechend()
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
}

export default Recorder