//
//  SettingsCoordinator.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import UIKit

protocol SettingsCoordinatorProtocol: CoordinatorProtocol {
    func openTutorial()
    
    func openTwitter()
    func openEmail()
    
    func openRateOnAppStore()
    func openTermsAndPrivacyPocily()
    func openAcknowledgements()
    
}

final class SettingsCoordinator: SettingsCoordinatorProtocol {
    
    // MARK: - Internal
    
    func buildInitialViewController() -> UIViewController {
        let settingsVC = SettingsViewController()
        let navigationVC = UINavigationController(rootViewController: settingsVC)
        
        let navigationCoordinator = NavigationCoordinator(navigationController: navigationVC)
        linkCoordinator = LinkCoordinator(navigationCoordinator: navigationCoordinator)
        
        return navigationVC
    }
    
        
    func openTutorial() {
        
    }
    
    func openTwitter() {
        guard let url = URL(string: "https://twitter.com/qstrnd") else { return }
        
        linkCoordinator?.open(url: url, options: [.openInApp])
    }
    
    func openEmail() {
        let email = "a.yakovlev@qstrnd.com"
        let subject = "Highlighter%20for%20Safari"
        let mailtoString = "mailto:\(email)?subject=\(subject)"
        
        guard let mailtoUrl = URL(string: mailtoString) else { return }
        
        linkCoordinator?.open(url: mailtoUrl)
    }
    
    func openRateOnAppStore() {
        
    }
    
    func openTermsAndPrivacyPocily() {
        
    }
    
    func openAcknowledgements() {
       
    }
    
    // MARK: - Private
    
    private var linkCoordinator: LinkCoordinatorProtocol?
    
    
}
