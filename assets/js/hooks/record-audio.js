class Recorder {
  constructor() {
    this.stream = undefined
    this.recorder = undefined
    this.audioChunks = []
    this.file = undefined
    this.audio = undefined
    this.options = {
      audioBitsPerSecond: 16000,
      channelCount: 1
    }
  }

  startRecording() {
    navigator
      .mediaDevices
      .getUserMedia({ audio: true, video: false })
      .then(stream => {
        this.recorder = new MediaRecorder(stream, this.options)
        this.recorder.start()

        this.recorder.addEventListener("dataavailable", event => {
          this.audioChunks.push(event.data);
        });

        this.recorder.addEventListener("stop", () => {
          const blob = new Blob(this.audioChunks, { 'type': 'audio/wav; codecs=0' });
          const audioUrl = URL.createObjectURL(blob);
          this.audio = new Audio(audioUrl);
          this.file = new File([blob], 'recording.wav', { type: blob.type })
          this.recorder = null
          this.stream = null
          document.getElementById("player").src = audioUrl
        })
      })
  }

  stopRecording() { this.recorder.stop() }

  playRecording() { this.audio.play() }
}

function submit() {
  document
    .getElementById('voice_sample-form')
    .dispatchEvent(new Event("submit", { bubbles: true, cancelable: true }))
}

function putFileInputValue(value) {
  document
    .getElementById("aws_path")
    .value = value
}

function disableSubmitButton(id) {
  const el = document.getElementById(id)
  el.setAttribute('disabled', true);
  el.innerText = "Saving..."
}

function enableSubmitButton(id) {
  const el = document.getElementById(id)
  el.setAttribute('disabled', false);
  el.innerText = "Save"
}

recorder = new Recorder()

const StartRecording = {
  mounted() {
    this.el.addEventListener('click', () => {
      this.el.classList.add('animate-pulse')
      this.el.classList.add('!text-red-800')

      stopButton = document.getElementById('stop-button')
      stopButton.classList.remove('!text-red-800')

      recorder.startRecording()
    })

  }
}

const StopRecording = {
  mounted() {
    this.el.addEventListener('click', () => {
      recorder.stopRecording()
      this.el.classList.add('!text-red-800')

      recordButton = document.getElementById('record-button')
      recordButton.classList.remove('animate-pulse')
      recordButton.classList.remove('!text-red-800')
    })
  }
}

const DeleteRecording = {
  mounted() {
    this.el.addEventListener('click', () => {
      this.recorder = null
      this.stream = null
      document.getElementById("player").src = ""
    })
  }
}

const SubmitRecording = {
  mounted() {
    hooks = this

    this.el
      .addEventListener('click', function (e) {
        recorder.file
          ? hooks.pushEventTo("#voice_sample-form", "generate_upload_url", {})
          : submit()
      });

    this.handleEvent('upload_url_generated', (e) => {
      disableSubmitButton('voice_sample-form-submit')
      fetch(e.url, { method: 'PUT', body: recorder.file })
        .then(function () {
          const url = new URL(e.url)
          putFileInputValue(url.pathname)
          submit()
        })
        .catch(function () {
          putFileInputValue("error")
          submit()
          putFileInputValue("")
          enableSubmitButton('voice_sample-form-submit')
        })
    })
  }
}

export { SubmitRecording, StartRecording, StopRecording, DeleteRecording } 