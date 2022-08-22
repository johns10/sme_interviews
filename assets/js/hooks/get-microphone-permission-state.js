const GetMicrophonePermissionState = {
  mounted() {
    navigator
      .permissions
      .query({ name: 'microphone' })
      .then(result => {
        updatePermissionState(this, result)
        result.onchange = result => updatePermissionState(this, result.target)
      })
  }
}

function updatePermissionState(hook, result) {
  hook.pushEvent("mic-permission-updated", { name: result.name, state: result.state })
}

export default GetMicrophonePermissionState