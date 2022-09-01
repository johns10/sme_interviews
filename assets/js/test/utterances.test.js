import { shiftBuffer, assignFile } from '../lib/utterances'

test('shift buffer works with 2 elements', () => {
    const chunks = shiftBuffer({ data: 3 }, [1, 2])
    expect(chunks).toStrictEqual([2, 3]);
})

test('shift buffer works with 1 elements', () => {
    const chunks = shiftBuffer({ data: 2 }, [1])
    expect(chunks).toStrictEqual([1, 2]);
})

test('shift buffer works with 0 elements', () => {
    const chunks = shiftBuffer({ data: 1 }, [])
    expect(chunks).toStrictEqual([1]);
})

describe('assignFile', () => {
    global.URL.createObjectURL = jest.fn();
    global.URL.createObjectURL = jest.fn(() => 'details');
    it('attaches an Audio when SpeechEvent exists', async () => {
        const args = { chunks: [new Blob(), new Blob()], speechEvent: {} }
        const result = await assignFile(args)
        expect(result).toStrictEqual(new File([new Blob()], ''))
    })
})
