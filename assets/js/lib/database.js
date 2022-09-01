export default class Database {
  constructor() {
    self.dbName = "SMEInterviews"
    self.objectStoreNames = ["models", "scorers"]
    self.store = null
  }

  async initialize() {
    this.store = await openIndexDB(self.dbName, self.objectStoreNames)
    return this
  }

  create({ type, id, ...attrs }) {
    return new Promise((resolve, reject) => {
      const transaction = this.store.transaction([type], "readwrite")
      const objectStore = transaction.objectStore(type)
      const request = objectStore.put(attrs, id)
      request.onsuccess = event => { resolve(event.target.result) }
      request.onError = event => { reject(event) }
    })
  }

  one({ type, id }) {
    return new Promise((resolve, reject) => {
      const transaction = this.store.transaction([type])
      const objectStore = transaction.objectStore(type)
      const request = objectStore.get(id)
      request.onsuccess = event => { resolve(event.target.result) }
      request.onError = event => { reject(event) }
    })
  }

  list({ type }) {
    return new Promise((resolve, reject) => {
      const transaction = this.store.transaction([type])
      const objectStore = transaction.objectStore(type)
      const request = objectStore.getAll()
      request.onsuccess = event => { resolve(event.target.result) }
      request.onError = event => { reject(event) }
    })
  }

  clear({ type }) {
    return new Promise((resolve, reject) => {
      const transaction = this.store.transaction([type], "readwrite")
      const objectStore = transaction.objectStore(type)
      const request = objectStore.clear();
      request.onsuccess = event => { resolve(event.target.result) }
      request.onError = event => { reject(event) }
    })
  }
}

async function openIndexDB(dbName, storeNames) {
  return new Promise(
    (resolve, reject) => {
      const request = indexedDB.open(dbName, 3);

      request.onerror = event => {
        reject(Error("Error text"));
      };

      request.onupgradeneeded = event => {
        const store = event.target.result;
        storeNames.map(storeName => store.createObjectStore(storeName))
      }

      request.onsuccess = event => {
        resolve(event.target.result);
      };
    }
  )
}