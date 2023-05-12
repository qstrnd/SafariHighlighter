//
//  CompositionRoot.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import UIKit
import Persistence

/// The Root for all DI in the app
final class CompositionRoot {
    
    // MARK: - Internal
    
    static var shared: CompositionRoot!
    
    init(windowScene: UIWindowScene) {
        self.windowScene = windowScene
    }
    
    let windowScene: UIWindowScene
    
    lazy var appStorage: AppStorage = {
        AppStorage()
    }()
    
    lazy var persistentExecutorFactory: PersistenceExecutorFactory = {
        PersistenceExecutorFactory(
            initialStoreOptions: .init(isPersistenceEnabled: false, isCloudSyncEnabled: false)
        )
    }()
    
    lazy var highlightsCoordinator: HighlightsCoordinatorProtocol = {
        HighlightsCoordinator(
            persistenceExecutorFactory: persistentExecutorFactory,
            appStorage: appStorage
        )
    }()
    
    lazy var settingsCoordinator: SettingsCoordinatorProtocol = {
        SettingsCoordinator(windowScene: windowScene)
    }()
    
    lazy var tabsCoordinator: TabCoordinator = {
        TabCoordinator(
            highlightsCoordinator: highlightsCoordinator,
            settingsCoordinator: settingsCoordinator,
            appStorage: appStorage
        )
    }()
}
