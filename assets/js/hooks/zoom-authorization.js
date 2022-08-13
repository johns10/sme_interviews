import zoomSdk from "@zoom/appssdk";

const ZoomAuthorizationHook = {
  mounted() {
    console.log("hook")
    zoomSdk.config({
      capabilities: [
        "authorize",
        "onAuthorized",
        "getUserContext"
      ]
    }).then(sdk => {
      zoomSdk.addEventListener("onAuthorized", (event) => {
        console.log(event)
      })
      zoomSdk.getUserContext().then(result => { console.log(result) })
    })
  }
};

export default ZoomAuthorizationHook;
