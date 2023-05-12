//
//  TabCoordinator.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import UIKit

final class TabCoordinator: CoordinatorProtocol {
    
    // MARK: - Internal

    init(
        highlightsCoordinator: CoordinatorProtocol,
        settingsCoordinator: CoordinatorProtocol
    ) {
        self.highlightsCoordinator = highlightsCoordinator
        self.settingsCoordinator = settingsCoordinator
    }
    
    func buildInitialViewController() -> UIViewController {
        let highlightsVC = highlightsCoordinator.buildInitialViewController()
        highlightsVC.tabBarItem = UITabBarItem(title: "Highlights", image: UIImage(systemName: "bookmark"), tag: 0)

        let settingsVC = settingsCoordinator.buildInitialViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [highlightsVC, settingsVC]

        return tabBarController
    }
    
    // MARK: - Private
    
    private let highlightsCoordinator: CoordinatorProtocol
    private let settingsCoordinator: CoordinatorProtocol
    
}
