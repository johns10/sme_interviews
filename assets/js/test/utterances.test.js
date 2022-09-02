import { shiftBuffer, assignFile } from '../lib/utterances'

describe('assignFile', () => {
    global.URL.createObjectURL = jest.fn();
    global.URL.createObjectURL = jest.fn(() => 'details');
    it('attaches an Audio when SpeechEvent exists', async () => {
        const args = { chunks: [new Blob(), new Blob()], speechEvent: {} }
        const result = await assignFile(args)
        expect(result).toStrictEqual(new File([new Blob()], ''))
    })
})
