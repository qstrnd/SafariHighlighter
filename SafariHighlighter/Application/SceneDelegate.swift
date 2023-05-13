//
//  SceneDelegate.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 30.03.2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        CompositionRoot.shared.windowScene = windowScene
        
        let initialViewController = CompositionRoot.shared.tabsCoordinator.buildInitialViewController()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = initialViewController
        window.makeKeyAndVisible()

        self.window = window
    }

}
