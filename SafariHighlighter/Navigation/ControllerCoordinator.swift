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

        let categoriesVC = buildCategoriesController(persistenceExecutorFactory: factory)
        let websitesVC = buildWebsitesController(persistenceExecutorFactory: factory)

        let groupedHighlightsVC = GroupedHighlightsViewController(groupingVCs: [categoriesVC, websitesVC])

        let navigationController = UINavigationController(rootViewController: groupedHighlightsVC)

        return navigationController
    }

    // MARK: - Private

    private init() {}

    private func buildCategoriesController(
        persistenceExecutorFactory: PersistenceExecutorFactory
    ) -> CategoriesViewController {
        let categoryFetchController = CategoryFetchController(
            options: .init(sortOrder: .creationDate, showOnlyCategoriesWithHighlights: false),
            persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor()
        )

        let categoryService = CategoryService(persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor())

        let categoriesViewController = CategoriesViewController(
            categoryFetchController: categoryFetchController,
            categoryService: categoryService
        )

        return categoriesViewController
    }

    private func buildWebsitesController(
        persistenceExecutorFactory: PersistenceExecutorFactory
    ) -> WebsitesViewController {
        let websiteFetchController = WebsiteFetchController(
            options: .init(sortOrder: .creationDate, showOnlyWebsitesWithHighlights: false),
            persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor()
        )

        let websiteService = WebsiteService(persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor())

        let websitesViewController = WebsitesViewController(
            websiteFetchController: websiteFetchController,
            websiteService: websiteService
        )

        return websitesViewController
    }
}
