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
        let message = item.userInfo?[SFExtensionMessageKey]

        Logger.appExtension.log("Received message from browser.runtime.sendNativeMessage: %@", message)

        let response = NSExtensionItem()
        response.userInfo = [ SFExtensionMessageKey: [ "Response to": message ] ]

        context.completeRequest(returningItems: [response], completionHandler: nil)
    }

}
