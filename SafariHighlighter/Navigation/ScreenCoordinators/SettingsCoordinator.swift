//
//  SettingsCoordinator.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import UIKit
import SwiftUI
import StoreKit
import MessageUI

protocol SettingsCoordinatorProtocol: CoordinatorProtocol {
    func openTutorial()
    
    func openTwitter()
    func openEmail()
    
    func openRateOnAppStore()
    func openTermsAndPrivacyPolicy()
    func openAcknowledgements()
    
}

final class SettingsCoordinator: NSObject, SettingsCoordinatorProtocol {
    
    // MARK: - Nested
    
    private enum Constants {
        static let termsPrivacyLink = "https://qstrnd.com/apps/safari-highlighter/terms-and-privacy"
        static let appStoreLink = "itms-apps://itunes.apple.com/app/idC8ZP5CBZNS?mt=8&action=write-review"
        static let twitterLink = "https://twitter.com/qstrnd"
        
        static let email = "a.yakovlev@qstrnd.com"
        static let mailSubject = "Highlighter for Safari"
        
        static var mailSubjectEscaped: String {
            Self.mailSubject.replacingOccurrences(of: " ", with: "%20")
        }
    }
    
    // MARK: - Internal
    
    init(windowScene: UIWindowScene) {
        self.windowScene = windowScene
    }
    
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
        guard let url = URL(string: Constants.twitterLink) else { return }
        
        linkCoordinator?.open(url: url, options: [.openInApp])
    }
    
    func openEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            openEmailToLink()
            return
        }

        openMailComposerController()
    }
    
    func openRateOnAppStore() {
        if #available(iOS 14.0, *) {
            SKStoreReviewController.requestReview(in: windowScene)
        } else if let appStoreUrl = URL(string: Constants.appStoreLink){
            linkCoordinator?.open(url: appStoreUrl)
        }
    }
    
    func openTermsAndPrivacyPolicy() {
        guard let url = URL(string: Constants.termsPrivacyLink) else { return }
        
        linkCoordinator?.open(url: url, options: [.openInApp])
    }
    
    func openAcknowledgements() {
        let acknowledgementsVC = UIHostingController(rootView: AcknowledgmentsView(acknowledgements: AcknowledgmentsView.defaultAcknowledgements))
        navigationCoordinator?.perform(navigation: .push(vc: acknowledgementsVC))
    }
    
    // MARK: - Private
    
    private let windowScene: UIWindowScene
    private var linkCoordinator: LinkCoordinatorProtocol?
    private var navigationCoordinator: NavigationCoordinator?
    
    private func openEmailToLink() {
        let mailtoString = "mailto:\(Constants.email)?subject=\(Constants.mailSubjectEscaped)"
        
        guard let mailtoUrl = URL(string: mailtoString) else { return }
        
        linkCoordinator?.open(url: mailtoUrl)
    }
    
    private func openMailComposerController() {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients([Constants.email])
        mailComposer.setSubject(Constants.mailSubject)
        
        navigationCoordinator?.perform(navigation: .present(vc: mailComposer))
    }
    
}

// MARK: - MFMailComposeViewControllerDelegate

extension SettingsCoordinator: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        navigationCoordinator?.perform(navigation: .dismiss(vc: controller))
    }
}
