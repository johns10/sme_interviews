import Devices from "./mocks/devices";
import { AudioContext } from 'standardized-audio-context-mock';
import MediaRecorder from './mocks/mediaRecorder';
import Recorder from '../lib/recorder';
import Corti from './mocks/corti'
import SpeechEvent from "../lib/speechEvent";

const FAKE_DATA = 'fake data'
const ONSPEECHSTART_MOCK = jest.fn()
const ONSPEECHEND_MOCK = jest.fn()

beforeEach(() => {
  Corti.patch()
  window.AudioContext = AudioContext
  window.MediaRecorder = MediaRecorder
  const mockMediaDevices = {
    getUserMedia: jest.fn().mockResolvedValueOnce(FAKE_DATA),
  };
  Object.defineProperty(window.navigator, 'mediaDevices', {
    writable: true,
    value: mockMediaDevices,
  });
})

test('initializes with the right stuff', async () => {
  const recorder = new Recorder({
    hooks: {},
    onspeechend: () => ONSPEECHEND_MOCK,
    onspeechstart: () => ONSPEECHSTART_MOCK
  })
  await recorder.initialize()
  expect(recorder.audioContext).toStrictEqual(new AudioContext())
  expect(recorder.stream).toStrictEqual(FAKE_DATA)
  expect(recorder.speechEvent).toBeInstanceOf(SpeechEvent)
  expect(recorder.recognize).toBeInstanceOf(window.SpeechRecognition)
})

test('responds correctly to speech events', async () => {
  const recorder = new Recorder({
    hooks: {},
    onspeechend: ONSPEECHEND_MOCK,
    onspeechstart: ONSPEECHSTART_MOCK
  })
  await recorder.initialize()
  const originalSpeechEvent = recorder.speechEvent

  recorder.recognize.startSpeechEvent()
  expect(originalSpeechEvent.status).toBe('started')
  expect(ONSPEECHSTART_MOCK).toBeCalled()

  recorder.recognize.endSpeechEvent()
  expect(ONSPEECHEND_MOCK).toBeCalled()
  expect(originalSpeechEvent.status).toBe('ended')
  expect(originalSpeechEvent === recorder.speechEvent).toBe(false)

  // console.log(originalSpeechEvent.recorder)
  // originalSpeechEvent.recorder.stop()

  // recorder.recognize.generateResults(FAKE_DATA)
  // recorder.recognize.resultEvent()
})