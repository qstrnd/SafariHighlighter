
// Reminder: messages in js extensions are communicated the following way:
// injected script -> background script -> application extension
// and the other way around.


// Send an message to the background script
browser.runtime.sendMessage(new Message(MESSAGE_TYPE_LOAD_TAGS), (response) => {
  console.log('Received response:', response);
});
