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

        let categoryFetchController = CategoryFetchController(
            options: .init(sortOrder: .creationDate, showOnlyCategoriesWithHighlights: false),
            persistanceExecutor: factory.getSharedPersistenceExecutor()
        )

        let categoryService = CategoryService(persistanceExecutor: factory.getSharedPersistenceExecutor())

        let categoryViewController = CategoriesViewController(
            categoryFetchController: categoryFetchController,
            categoryService: categoryService
        )

        let navigationController = UINavigationController(rootViewController: categoryViewController)

        return navigationController
    }

    // MARK: - Private

    private init() {}
}
