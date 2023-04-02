//
//  Error.swift
//  SafariHighlighterExtension
//
//  Created by Andrey Yakovlev on 01.04.2023.
//

import Foundation

enum MessageError: Error {
    case invalidMessage
    case missingMessageType
    case invalidMessageType(String)
    case invalidMessageParameters(type: String, parameters: [String: String])
}
