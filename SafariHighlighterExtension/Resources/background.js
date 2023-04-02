browser.runtime.onMessage.addListener((message, sender, sendResponse) => {
    console.log("Received a message from injected script: ", message.type, " with parameters: ", message.parameters);

    if (message.requiresNative) {
        browser.runtime.sendNativeMessage(APPLICATION_ID, message, response => {
            sendResponse(response);
        });
    } else {
        // non native messaging handling goes here
        message.parameters.status = MESSAGE_STATUS_HANDLED
        sendResponse(message)
    }
    
    // the return value determines whether sendResponse will outlive function body
    // return true to indicate we're waiting for asynchronous response
    return message.requiresNative 
});
