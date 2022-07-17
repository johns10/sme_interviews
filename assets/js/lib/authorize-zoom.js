import zoomSdk from "@zoom/appssdk"

zoomSdk = window.zoomSdk

window.addEventListener("phx:configure_zoom_sdk", () => configureZoomSdk)
window.addEventListener("phx:authorize_zoom_user", () => authorizeUser)

window.dec2hex = function (dec) {
  return ("0" + dec.toString(16)).substr(-2);
}

window.generateCodeVerifier = function () {
  var array = new Uint32Array(56 / 2);
  window.crypto.getRandomValues(array);
  return Array.from(array, dec2hex).join("");
}

window.sha256 = function (plain) {
  // returns promise ArrayBuffer
  const encoder = new TextEncoder();
  const data = encoder.encode(plain);
  return window.crypto.subtle.digest("SHA-256", data);
}

window.base64urlencode = function (a) {
  var str = "";
  var bytes = new Uint8Array(a);
  var len = bytes.byteLength;
  for (var i = 0; i < len; i++) {
    str += String.fromCharCode(bytes[i]);
  }
  return btoa(str)
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=+$/, "");
}

window.generateCodeChallengeFromVerifier = async function (v) {
  var hashed = await sha256(v);
  var base64encoded = base64urlencode(hashed);
  return base64encoded;
}

window.configureZoomSdk = function() {
  console.log("configure zoom sdk")
  return zoomSdk.config({capabilities: [
    "authorize", 
    "onAuthorized"
  ]})
}

window.authorizeUser = function () {
  window.configureZoomSdk().then(() => {
    return generateCodeVerifier();
  }).then(challenge => {
    return zoomSdk.callZoomApi("authorize", {codeChallenge: challenge});
  }).then(res => {
    console.log(res)
  })
}
