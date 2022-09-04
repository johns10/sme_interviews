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
              resolve(fileArray);
            } else {
              if (value) chunks.push(value)
              return reader.read().then(storeChunk)
            }
          })
        })
    }
  )
}

export { fetchFile }