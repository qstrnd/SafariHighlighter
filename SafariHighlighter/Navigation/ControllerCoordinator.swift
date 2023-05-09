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

public enum HighlightsGroupBy {
    case website(Website)
    case category(Persistence.Category)
}

protocol IHighlightsControllerCoordinator: AnyObject {
    func buildHighlightsController(groupBy: HighlightsGroupBy) -> UIViewController
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
        let highlightsNavigationVC = UINavigationController(rootViewController: groupedHighlightsVC)
        highlightsNavigationVC.tabBarItem = UITabBarItem(title: "Highlights", image: UIImage(systemName: "bookmark"), tag: 0)

        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [highlightsNavigationVC, settingsVC]

        return tabBarController
    }
}

// MARK: - IHighlightsControllerCoordinator
extension ControllerCoordinator: IHighlightsControllerCoordinator {
    func buildHighlightsController(groupBy: HighlightsGroupBy) -> UIViewController {
        let groupByOption = highlightsFetchControllerGroupBy(from: groupBy)

        let highlightFetchController = HighlightFetchController(
            options: .init(sortOrder: .creationDate, groupBy: groupByOption),
            persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor()
        )

        let highlightService = HighlightService(persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor())
        let categoryService = CategoryService(persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor())
        let websiteService = WebsiteService(persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor())

        let relationshipService = RelationshipService(
            highlighService: highlightService,
            categoryService: categoryService,
            websiteService: websiteService,
            persistanceExecutor: persistenceExecutorFactory.getSharedPersistenceExecutor()
        )

        let highlightsViewController = HighlightsViewController(
            highlightFetchController: highlightFetchController,
            highlightService: highlightService,
            relationshipService: relationshipService,
            groupByTrait: groupBy
        )

        return highlightsViewController
    }

    private func highlightsFetchControllerGroupBy(from groupBy: HighlightsGroupBy) -> HighlightFetchController.Options.GroupBy {
        switch groupBy {
        case .category(let category):
            return .category(uniqueId: category.uniqueId)
        case .website(let website):
            return .website(uniqueId: website.uniqueId)
        }
    }
}
