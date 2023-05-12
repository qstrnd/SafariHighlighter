//
//  CompositionRoot.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import Foundation
import Persistence

/// The Root for all DI in the app
final class CompositionRoot {
    
    // MARK: - Internal
    
    static let shared = CompositionRoot()
    
    lazy var persistentExecutorFactory: PersistenceExecutorFactory = {
        PersistenceExecutorFactory(
            initialStoreOptions: .init(isPersistenceEnabled: false, isCloudSyncEnabled: false)
        )
    }()
    
    lazy var highlightsCoordinator: HighlightsCoordinatorProtocol = {
        HighlightsCoordinator(persistenceExecutorFactory: persistentExecutorFactory)
    }()
    
    lazy var settingsCoordinator: SettingsCoordinatorProtocol = {
        SettingsCoordinator()
    }()
    
    lazy var tabsCoordinator: TabCoordinator = {
        TabCoordinator(
            highlightsCoordinator: highlightsCoordinator,
            settingsCoordinator: settingsCoordinator
        )
    }()
    
    // MARK: - Private
    
    private init() {}
}
