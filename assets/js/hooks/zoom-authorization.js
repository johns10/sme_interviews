const ZoomAuthorizationHook = {
    mounted() {
      console.log("hook")
      window.configureZoomSdk().then(sdk => {
        sdk.addEventListener("onAuthorized", (event) => {
          console.log(event)
        })
      })
    }
  };
  
  export default ZoomAuthorizationHook;
  