
import Recorder from '../lib/recorder';
import Database from '../lib/database'
import Alpine from 'alpinejs';
database = new Database();

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
    recorderManager = new Recorder({
      hooks: this,
      onspeechstart: Alpine.store('recorder').startSpeaking,
      onspeechend: Alpine.store('recorder').stopSpeaking
    })
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
