import zoomSdk from "@zoom/appssdk";

const ZoomAuthorizationHook = {
  mounted() {
    window.configureZoomSdk().then(sdk => {
      zoomSdk.addEventListener("onAuthorized", (event) => {
        console.log(event)
      })
    })
  }
};

export default ZoomAuthorizationHook;
