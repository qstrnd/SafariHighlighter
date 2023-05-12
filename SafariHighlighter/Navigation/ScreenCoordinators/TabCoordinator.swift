//
//  TabCoordinator.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import UIKit
import SwiftUI

final class TabCoordinator: NSObject, CoordinatorProtocol {
    
    // MARK: - Internal

    init(
        highlightsCoordinator: CoordinatorProtocol,
        settingsCoordinator: CoordinatorProtocol,
        appStorage: AppStorage
    ) {
        self.highlightsCoordinator = highlightsCoordinator
        self.settingsCoordinator = settingsCoordinator
        self.appStorage = appStorage
    }
    
    func buildInitialViewController() -> UIViewController {
        let highlightsVC = highlightsCoordinator.buildInitialViewController()
        highlightsVC.tabBarItem = UITabBarItem(title: "Highlights", image: UIImage(systemName: "bookmark.fill"), tag: 0)

        let settingsVC = settingsCoordinator.buildInitialViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [highlightsVC, settingsVC]
        tabBarController.delegate = self
        tabBarController.selectedIndex = appStorage.selectedTab
        
        if !appStorage.isTutorialShown {
            presentTutorialDelayed()
        }
        
        self.tabBarController = tabBarController

        return tabBarController
    }
    
    // MARK: - Private
    
    private let highlightsCoordinator: CoordinatorProtocol
    private let settingsCoordinator: CoordinatorProtocol
    private let appStorage: AppStorage
    
    private var tabBarController: UITabBarController?
    
    private func presentTutorialDelayed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let tutorialVC = UIHostingController(rootView: TutorialView())
            self.tabBarController?.present(tutorialVC, animated: true) {
                self.appStorage.isTutorialShown = true
            }
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension TabCoordinator: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        appStorage.selectedTab = viewController.tabBarItem.tag
    }
    
}
