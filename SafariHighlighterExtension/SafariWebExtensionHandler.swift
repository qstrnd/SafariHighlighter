//
//  SafariWebExtensionHandler.swift
//  SafariHighlighter Extension
//
//  Created by Andrey Yakovlev on 30.03.2023.
//

import SafariServices
import Common

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem

        guard let messageDictionary = (item.userInfo?[SFExtensionMessageKey] as? NSDictionary) else {
            Logger.appExtension.log("Cannot convert the message to NSDictionary", type: .error)
            context.cancelRequest(withError: MessageError.invalidMessage)
            return
        }

        guard let messageTypeRaw = messageDictionary.value(forKey: "type") as? String else {
            Logger.appExtension.log("Received a message without type", type: .error)
            context.cancelRequest(withError: MessageError.missingMessageType)
            return
        }

        guard let messageType = MessageType(rawValue: messageTypeRaw) else {
            Logger.appExtension.log("Invalid message type: %@", messageTypeRaw)
            context.cancelRequest(withError: MessageError.invalidMessageType(messageTypeRaw))
            return
        }

        Logger.appExtension.log("Received a message from browser.runtime.sendNativeMessage: %@", messageDictionary)

        let messageParametersNSDictionary = messageDictionary.value(forKey: "parameters") as? NSDictionary
        var messageParameters = messageParametersNSDictionary?.asDictionary() ?? [:]

        switch messageType {
        case .loadTags:
            let response = NSExtensionItem()
            response.userInfo = [ SFExtensionMessageKey: [ "status": "handled load tags" ] ]

            context.completeRequest(returningItems: [response], completionHandler: nil)
        case .addTag:
            break
        case .removeTag:
            break
        }
    }

}
