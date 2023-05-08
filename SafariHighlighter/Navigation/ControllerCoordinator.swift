//
//  ControllerCoordinator.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 22.04.2023.
//

import UIKit
import Persistence

protocol IRootControllerCoordinator: AnyObject {
    func buildInitialViewController() -> UIViewController
}

public enum HighlightsControllerGroupBy {
    case category(uniqueId: UUID)
    case website(uniqueId: UUID)
}

protocol IHighlightsControllerCoordinator: AnyObject {
    func buildHighlightsController(groupBy: HighlightsControllerGroupBy) -> UIViewController
}

final class ControllerCoordinator {

    // MARK: - Internal

    static let shared = ControllerCoordinator()

    func buildGroupedHighlightsViewController() -> UIViewController {
        let categoriesVC = buildCategoriesController()
        let websitesVC = buildWebsitesController()

        return GroupedHighlightsViewController(groupingVCs: [categoriesVC, websitesVC])
    }

    // MARK: - Private

    private let persistenceExecutorFactory = PersistenceExecutorFactory(
        initialStoreOptions: .init(isPersistenceEnabled: false, isCloudSyncEnabled: false)
    )

    private init() {}

    private func buildCategoriesController() -> CategoriesViewController {
        let categoryFetchController = CategoryFetchController(
            options: .init(sortOrder: .creationDate, showOnlyCategoriesWithHighlights: false),
            persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor()
        )

        let categoryService = CategoryService(persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor())

        let categoriesViewController = CategoriesViewController(
            categoryFetchController: categoryFetchController,
            categoryService: categoryService,
            highlightsCoordinator: self
        )

        return categoriesViewController
    }

    private func buildWebsitesController() -> WebsitesViewController {
        let websiteFetchController = WebsiteFetchController(
            options: .init(sortOrder: .creationDate, showOnlyWebsitesWithHighlights: false),
            persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor()
        )

        let websiteService = WebsiteService(persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor())

        let websitesViewController = WebsitesViewController(
            websiteFetchController: websiteFetchController,
            websiteService: websiteService,
            highlightsCoordinator: self
        )

        return websitesViewController
    }
}

// MARK: - IRootControllerCoordinator
extension ControllerCoordinator: IRootControllerCoordinator {
    func buildInitialViewController() -> UIViewController {
        let groupedHighlightsVC = buildGroupedHighlightsViewController()
        let navigationController = UINavigationController(rootViewController: groupedHighlightsVC)

        return navigationController
    }
}

// MARK: - IHighlightsControllerCoordinator
extension ControllerCoordinator: IHighlightsControllerCoordinator {
    func buildHighlightsController(groupBy: HighlightsControllerGroupBy) -> UIViewController {
        let groupBy = highlightsFetchControllerGroupBy(from: groupBy)

        let highlightFetchController = HighlightFetchController(
            options: .init(sortOrder: .creationDate, groupBy: groupBy),
            persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor()
        )

        let highlightService = HighlightService(
            persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor()
        )

        let highlightsViewController = HighlightsViewController(
            highlightFetchController: highlightFetchController,
            highlightService: highlightService
        )

        return highlightsViewController
    }

    private func highlightsFetchControllerGroupBy(from groupBy: HighlightsControllerGroupBy) -> HighlightFetchController.Options.GroupBy {
        switch groupBy {
        case .category(let uniqueId):
            return .category(uniqueId: uniqueId)
        case .website(let uniqueId):
            return .website(uniqueId: uniqueId)
        }
    }
}
