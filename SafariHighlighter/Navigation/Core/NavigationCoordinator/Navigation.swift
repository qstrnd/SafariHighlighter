//
//  Navigation.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import UIKit

enum Navigation {
    case present(vc: UIViewController)
    case push(vc: UIViewController)
    case dismiss(vc: UIViewController)
    case pop(vc: UIViewController)
    case popLast
    case dismissLast
    case returnToRoot
}

extension Navigation: Equatable {
    
    static func == (lhs: Navigation, rhs: Navigation) -> Bool {
        switch (lhs, rhs) {
        case let (.present(vc1), .present(vc2)):
            return vc1 == vc2
        case let (.push(vc1), .push(vc2)):
            return vc1 == vc2
        case let (.dismiss(vc1), .dismiss(vc2)):
            return vc1 == vc2
        case let (.pop(vc1), .pop(vc2)):
            return vc1 == vc2
        case (.popLast, .popLast):
            return true
        case (.dismissLast, .dismissLast):
            return true
        case (.returnToRoot, .returnToRoot):
            return true
        default:
            return false
        }
    }
    
}
