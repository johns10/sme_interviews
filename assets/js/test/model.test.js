import Database from '../lib/database'
import * as Models from '../lib/models'
require("fake-indexeddb/auto");

const database = new Database()

beforeAll(async () => { return database.initialize() })

test('put model works', async () => {
  const attrs = { blob: "test", version: 1 }
  await Models.createModel(database, attrs)
  const result = await Models.getModel(database, attrs.version)
  const { version, ...fields } = attrs
  expect(result).toStrictEqual(fields);
})

test('list models works', async () => {
  const attrs = { blob: "test", version: 1 }
  await Models.createModel(database, attrs)
  const result = await Models.listModels(database)
  const { version, ...fields } = attrs
  expect(result).toStrictEqual([fields])
})

test('clear model works', async () => {
  const attrs = { blob: "test", version: 1 }
  await Models.createModel(database, attrs)
  await Models.clearModels(database)
  const result = await Models.listModels(database, attrs.version)
  expect(result).toStrictEqual([])
})