import zoomSdk from "@zoom/appssdk";

const ZoomAuthorizationHook = {
    mounted() {
      console.log("hook")
      window.configureZoomSdk().then(sdk => {
        zoomSdk.addEventListener("onAuthorized", (event) => {
          console.log(event)
        })
      })
    }
  };
  
  export default ZoomAuthorizationHook;
  