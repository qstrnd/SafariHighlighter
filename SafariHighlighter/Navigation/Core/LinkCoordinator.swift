//
//  LinkCoordinator.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import UIKit
import SafariServices

enum LinkCoordinatorOption {
    case openInApp
}

protocol LinkCoordinatorProtocol: AnyObject {
    func open(url: URL, options: Set<LinkCoordinatorOption>)
}

extension LinkCoordinatorProtocol {
    func open(url: URL) {
        open(url: url, options: [])
    }
}

final class LinkCoordinator: LinkCoordinatorProtocol {
    
    // MARK: - Internal
        
    init(navigationCoordinator: NavigationCoordinatorProtocol) {
        self.navigationCoordinator = navigationCoordinator
    }
    
    func open(url: URL, options: Set<LinkCoordinatorOption>) {
        if options.contains(.openInApp) {
            let safariVC = SFSafariViewController(url: url)
            navigationCoordinator.perform(navigation: .present(vc: safariVC))
        } else {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Private
    
    private let navigationCoordinator: NavigationCoordinatorProtocol

}
