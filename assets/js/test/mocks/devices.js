export default class Devices {
  connectAudioDevice(device) {
    return new Promise((resolve, reject) => {
      navigator.mediaDevices
        .getUserMedia({ audio: true })
        .then((stream) => {
          resolve(stream);
        })
        .catch((error) => {
          resolve(error);
        });
    });
  }
}