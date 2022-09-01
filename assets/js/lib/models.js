const MODEL_NAME = "models"

function createModel(db, { blob, version }) {
  return db.create({ type: MODEL_NAME, blob, id: version })
}

function getModel(db, version) {
  return db.one({ type: MODEL_NAME, id: version })
}

function listModels(db) {
  return db.list({ type: MODEL_NAME })
}

function clearModels(db) {
  return db.clear({ type: MODEL_NAME })
}

export { createModel, getModel, clearModels, listModels }