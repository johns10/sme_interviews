import { fetchFile } from './utils'

const MODEL_NAME = "models"

function createModel(db, { blob, id }) {
  return db.create({ type: MODEL_NAME, blob, id })
}

function getModel(db, id) {
  return db.one({ type: MODEL_NAME, id })
}

function listModels(db) {
  return db.list({ type: MODEL_NAME })
}

function clearModels(db) {
  return db.clear({ type: MODEL_NAME })
}

async function ensureModel(db, { fileName, version, url }) {
  const id = fileName + version
  const result = await getModel(db, id)
  if (result) return result
  else {
    const blob = await fetchFile(url)
    await createModel(db, { blob, id })
    return blob
  }
}

export { createModel, getModel, clearModels, listModels, ensureModel }
