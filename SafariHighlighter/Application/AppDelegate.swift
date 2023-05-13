//
//  AppDelegate.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 30.03.2023.
//

import UIKit
import Common

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        if !CompositionRoot.shared.appStorage.areInitialCategoriesGenerated {
            CompositionRoot.shared.initialCategoriesProducer.generateInitialCategories {
                CompositionRoot.shared.appStorage.areInitialCategoriesGenerated = true
            }
        }
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}
