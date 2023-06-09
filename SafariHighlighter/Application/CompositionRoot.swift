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
    
    static var shared = CompositionRoot()
    
    var windowScene: UIWindowScene!
    
    lazy var appStorage: AppStorage = {
        AppStorage()
    }()

    lazy var tracker: TrackerProtocol = {
        Tracker()
    }()
    
    lazy var imageCacheService: ImageCacheServiceProtocol = {
        ImageCacheService()
    }()
    
    lazy var persistentExecutorFactory: persistanceExecutorFactory = {
        persistanceExecutorFactory(
            initialStoreOptions: .init(isPersistenceEnabled: true, isCloudSyncEnabled: false)
        )
    }()
    
    lazy var categoryService: CategoryService = {
        CategoryService(persistanceExecutor: persistentExecutorFactory.getSharedpersistanceExecutor())
    }()
    
    lazy var initialCategoriesProducer: InitialCategoriesProducer = {
        InitialCategoriesProducer(
            categoryService: categoryService,
            appStorage: appStorage
        )
    }()
    
    lazy var highlightsCoordinator: HighlightsCoordinatorProtocol = {
        HighlightsCoordinator(
            persistanceExecutorFactory: persistentExecutorFactory,
            appStorage: appStorage,
            imageCacheService: imageCacheService,
            tracker: tracker
        )
    }()
    
    lazy var settingsCoordinator: SettingsCoordinatorProtocol = {
        SettingsCoordinator(windowScene: windowScene, tracker: tracker)
    }()
    
    lazy var tabsCoordinator: TabCoordinator = {
        TabCoordinator(
            highlightsCoordinator: highlightsCoordinator,
            settingsCoordinator: settingsCoordinator,
            appStorage: appStorage,
            tracker: tracker
        )
    }()
    
    // MARK: - Private
    
    init() {}
}
