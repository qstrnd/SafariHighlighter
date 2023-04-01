browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("Received request: ", request);

    if (request.type === "initial") {
        console.log("Initial")
    }

    browser.runtime.sendNativeMessage("application.id", {message: "initial"}, function(response) {
        console.log("Received sendNativeMessage response:");
        sendResponse({ farewell: "goodbye from app" });
    });

    return true // to indicate we're waiting for asynchronous response
});
