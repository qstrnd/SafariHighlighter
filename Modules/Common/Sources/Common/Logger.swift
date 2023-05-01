//
//  Logger.swift
//  
//
//  Created by Andrey Yakovlev on 30.03.2023.
//

import Foundation
import os.log

public class Logger {

    static func make(for category: String) -> OSLog {
        OSLog(subsystem: "com.qstrnd.safariHighlighter", category: category)
    }

    public static let mainApplication = make(for: "mainApplication")
    public static let appExtension = make(for: "appExtension")
    public static let persistence = make(for: "persistence")

}

public extension OSLog {
    func log(_ message: StaticString, type: OSLogType = .default, _ arguments: Any?...) {
        let args: [String] = arguments.map { argument in
            if let stringArgument = argument as? String {
                return stringArgument
            }

            guard let nonNilArgument = argument else {
                return "nil"
            }

            return String(describing: nonNilArgument)
        }

        switch args.count {
        case 0:
            os_log(type, log: self, message)
        case 1:
            os_log(type, log: self, message, args[0])
        case 2:
            os_log(type, log: self, message, args[0], args[1])
        case 3:
            os_log(type, log: self, message, args[0], args[1], args[2])
        case 4:
            os_log(type, log: self, message, args[0], args[1], args[2], args[3])
        case 5:
            os_log(type, log: self, message, args[0], args[1], args[2], args[3], args[4])
        default:
            assertionFailure("Too many arguments for a single log mesasge. Processing only the first 5")
            os_log(type, log: self, message, args[0], args[1], args[2], args[3], args[4])
        }
    }
}
