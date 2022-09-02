import { v4 } from 'uuid';

function assignFile({ chunks, speechEvent }) {
  const blob = new Blob(chunks, { 'type': 'audio/wav; codecs=0' });
  return new File([blob], `${speechEvent.id}.wav`, { type: blob.type })
}

function putAudio({ url, file }) {
  return fetch(url, { method: 'put', body: file })
}

function newSpeechEvent() {
  return {
    id: v4(),
    status: 'started',
    audio: null,
    url: null
  }
}

export { assignFile, newSpeechEvent, putAudio }