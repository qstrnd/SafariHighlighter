document.body.style.backgroundColor = "red";

// Send a message to the background script
console.log("sent message");
browser.runtime.sendMessage({type: "initial"}, function(response) {
  console.log('Received response:', response);
});

