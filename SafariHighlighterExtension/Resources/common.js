// Application

const APPLICATION_ID = "application.id"; // Safari ignores this string because it doesn't allow sending messages to other apps

// Message types

const MESSAGE_TYPE_LOAD_TAGS = "LOAD_TAGS";
const MESSAGE_TYPE_ADD_TAG = "ADD_TAG";
const MESSAGE_TYPE_REMOVE_TAG = "REMOVE_TAG";

/**
 * Message represents the message exchanged between scripts and native extension
 * 
 * @class Message
 */
class Message {

    /**
     * Creates an instance of Message.
     * @param {MESSAGE_TYPE} type used to indicate the type of message
     * @param {Object} [parameters={}] used to wrap parameters for the message
     * @param {boolean} [requiresNative=true] if true, the message is forwarded to the native app extension
     * @memberof Message
     */
    constructor(type, parameters = {}, requiresNative = true) {
        this.type = type
        this.parameters = parameters
        this.requiresNative = true
    }
}
