//
//  CoordinatorProtocol.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    func buildInitialViewController() -> UIViewController
}
