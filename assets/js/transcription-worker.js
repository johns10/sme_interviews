import { ensureModel } from './lib/models'
import Database from './lib/database'
import STT from './lib/stt_wasm'

var activeModel
var stt

self.onmessage = async ({ data: data }) => {
  const { type, ...attrs } = data
  if (type == 'start') start(attrs)
  if (type == 'transcribe') transcribe(attrs)
  if (type == 'poll') status()
}

async function start({ modelData, scorerData }) {
  stt = await STT()
  const db = new Database()
  await db.initialize()
  const status = { scorer: { loaded: false }, model: { loaded: false } }
  try {
    const modelFile = await ensureModel(db, modelData)
    activeModel = new stt.Model(modelFile.blob);
    status.model.loaded = true
  } catch (e) { console.log(e); status.model.error = e }
  try {
    const scorerFile = await ensureModel(db, scorerData)
    activeModel.enableExternalScorer(scorerFile.blob);
    status.scorer.loaded = true
  } catch (e) { status.scorer.error = e }
  postMessage({ type: 'started', ...status })
}

async function transcribe({ id, audio, text, status, ...rest }) {
  const toPass = new stt.VectorShort();
  audio.forEach(e => toPass.push_back(e));
  const now = Date.now();
  const result = activeModel.speechToText(toPass);
  postMessage({ type: 'transcription-finished', text: result, status: "transcription_complete", id, ...rest })
}

async function status() { postMessage({ type: 'idle' }) }