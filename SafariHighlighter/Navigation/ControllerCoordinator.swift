//
//  ControllerCoordinator.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 22.04.2023.
//

import UIKit
import Persistence

protocol IRootControllerCoordinator {
    func buildInitialViewController() -> UIViewController
}

final class ControllerCoordinator: IRootControllerCoordinator {

    // MARK: - Internal

    static let shared = ControllerCoordinator()

    func buildInitialViewController() -> UIViewController {
        let factory = PersistenceExecutorFactory(initialStoreOptions: .init(isPersistenceEnabled: false, isCloudSyncEnabled: false))

//        let categoryFetchController = CategoryFetchController(
//            options: .init(sortOrder: .creationDate, showOnlyCategoriesWithHighlights: false),
//            persistanceExecutor: factory.getSharedPersistenceExecutor()
//        )
//
//        let categoryService = CategoryService(persistanceExecutor: factory.getSharedPersistenceExecutor())
//
//        let categoriesViewController = CategoriesViewController(
//            categoryFetchController: categoryFetchController,
//            categoryService: categoryService
//        )

        let websiteFetchController = WebsiteFetchController(
            options: .init(sortOrder: .creationDate, showOnlyWebsitesWithHighlights: false),
            persistanceExecutor: factory.getSharedPersistenceExecutor()
        )

        let websiteService = WebsiteService(persistanceExecutor: factory.getSharedPersistenceExecutor())

        let websitesViewController = WebsitesViewController(
            websiteFetchController: websiteFetchController,
            websiteService: websiteService
        )

        let navigationController = UINavigationController(rootViewController: websitesViewController)

        return navigationController
    }

    // MARK: - Private

    private init() {}
}
