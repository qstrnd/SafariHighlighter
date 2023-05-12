//
//  SettingsCoordinator.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import UIKit
import SwiftUI

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
        let settingsVC = SettingsViewController(coordinator: self)
        let navigationVC = UINavigationController(rootViewController: settingsVC)
        
        let navigationCoordinator = NavigationCoordinator(navigationController: navigationVC)
        self.navigationCoordinator = navigationCoordinator
        
        linkCoordinator = LinkCoordinator(navigationCoordinator: navigationCoordinator)
        
        return navigationVC
    }
    
        
    func openTutorial() {
        let tutorialVC = UIHostingController(rootView: TutorialView())
        navigationCoordinator?.perform(navigation: .push(vc: tutorialVC))
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
        // TODO: Also use SKStoreProductViewController
        guard let appStoreUrl = URL(string: "itms-apps://itunes.apple.com/app/idXXX") else { return }
        
        linkCoordinator?.open(url: appStoreUrl)
    }
    
    func openTermsAndPrivacyPocily() {
        
    }
    
    func openAcknowledgements() {
        let acknowledgementsVC = UIHostingController(rootView: AcknowledgmentsView(acknowledgements: AcknowledgmentsView.defaultAcknowledgements))
        navigationCoordinator?.perform(navigation: .push(vc: acknowledgementsVC))
    }
    
    // MARK: - Private
    
    private var linkCoordinator: LinkCoordinatorProtocol?
    private var navigationCoordinator: NavigationCoordinator?
    
}
