class mockMediaRecorder {
  constructor() {
    this.start = jest.fn()
    this.onerror = jest.fn()
    this.state = ""
    this.stop = () => this.ondataavailable({ event: { data: [] } })
  }
};

export default mockMediaRecorder