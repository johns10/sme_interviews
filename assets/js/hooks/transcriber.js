var worker

const Transcriber = {
  async mounted() {
    audioContext = new AudioContext()
    worker = new Worker('assets/transcription-worker.js', { type: 'module' })
    const { ...modelData } = document.getElementById("model-data").dataset
    const { ...scorerData } = document.getElementById("scorer-data").dataset
    this.handleEvent("utterance-available", () => worker.postMessage({ type: 'poll' }))
    worker.postMessage({ type: 'start', modelData, scorerData, url: window.location.origin + "/assets/" })
    worker.onmessage = ({ data: data }) => {
      const { type } = data
      if (type == 'started') this.pushEvent('transcriber-idle', {}, startTranscribing)
      if (type == 'idle') this.pushEvent('transcriber-idle', {}, startTranscribing)
      if (type == 'transcription-finished') {
        this.pushEvent(type, data)
        this.pushEvent('transcriber-idle', {}, startTranscribing)
      }
    }
  }
};

export default Transcriber

function converFloat32ToInt16(buffer) {
  return Int16Array.from(buffer, x => x * 32767);
}

async function fetchAudio(url) {
  const response = await fetch(url)
  const buffer = await response.arrayBuffer()
  const audioData = await audioContext.decodeAudioData(buffer)
  return converFloat32ToInt16(audioData.getChannelData(0));
}

async function startTranscribing({ entry }) {
  if (entry) {
    audio = await fetchAudio(entry.get_url)
    worker.postMessage({ type: 'transcribe', audio, ...entry })
  }
}