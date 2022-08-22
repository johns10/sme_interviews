const RequestMicrophoneAccess = {
  mounted() {
    this.el.addEventListener('click', () => {
      navigator
        .mediaDevices
        .getUserMedia({ audio: true, video: false })
        .then(stream => {
          stream
            .getTracks()
            .forEach(track => track.stop())
        })
    })
  }
}

export default RequestMicrophoneAccess