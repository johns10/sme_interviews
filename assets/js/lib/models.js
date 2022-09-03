const MODEL_NAME = "models"

function createModel(db, { blob, id }) {
  return db.create({ type: MODEL_NAME, blob, id })
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

async function ensureModel(db, version, url) {
  result = await getModel(db, version)
  if (result) return result
  else {
    const blob = await fetchFile(url)
    await createModel(db, { blob, version })
    return blob
  }
}

export { createModel, getModel, clearModels, listModels, ensureModel }

function fetchFile(url) {
  return new Promise(
    (resolve, reject) => {
      fetch(url)
        .then(response => {
          const reader = response.body.getReader()
          const chunks = []
          reader.read().then(function storeChunk({ done, value }) {
            if (done) {
              const length = chunks.reduce((acc, chunk) => acc + chunk.length, 0)
              const { result: fileArray } = chunks.reduce(({ offset, result }, chunk) => {
                const newOffset = offset + chunk.length;
                result.set(chunk, offset)
                return { offset: newOffset, result: result }
              }, { offset: 0, result: new Uint8Array(length) })
              resolve(new Blob([fileArray]));
            } else {
              if (value) chunks.push(value)
              return reader.read().then(storeChunk)
            }
          })
        })
    }
  )
}