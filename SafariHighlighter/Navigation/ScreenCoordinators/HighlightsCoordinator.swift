//
//  HighlightsCoordinator.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 22.04.2023.
//

import UIKit
import Persistence

public enum HighlightsGroupBy {
    case website(Website)
    case category(Persistence.Category)
    
    var title: String {
        switch self {
        case .category(let category):
            return category.name
        case .website(let website):
            return website.name
        }
    }
}

protocol HighlightsCoordinatorProtocol: CoordinatorProtocol {
    func openHighlights(groupBy: HighlightsGroupBy)
}

final class HighlightsCoordinator: HighlightsCoordinatorProtocol {
    
    // MARK: - Internal

    init(
        persistenceExecutorFactory: PersistenceExecutorFactory,
        appStorage: AppStorage
    ) {
        self.persistenceExecutorFactory = persistenceExecutorFactory
        self.appStorage = appStorage
    }
    
    // MARK: - Private
    
    private let persistenceExecutorFactory: PersistenceExecutorFactory
    private let appStorage: AppStorage
    private var navigationCoordinator: NavigationCoordinator?
    
    private func buildGroupedHighlightsViewController() -> UIViewController {
        let categoriesVC = buildCategoriesController()
        let websitesVC = buildWebsitesController()
        
        return GroupedHighlightsViewController(groupingVCs: [categoriesVC, websitesVC], appStorage: appStorage)
    }
    
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

// MARK: - Coordinator
extension HighlightsCoordinator {
    func buildInitialViewController() -> UIViewController {
        let groupedHighlightsVC = buildGroupedHighlightsViewController()
        let highlightsNavigationVC = UINavigationController(rootViewController: groupedHighlightsVC)
        
        navigationCoordinator = NavigationCoordinator(navigationController: highlightsNavigationVC)
        
        return highlightsNavigationVC
    }
}

// MARK: - HighlightsCoordinatorProtocol
extension HighlightsCoordinator {
    func openHighlights(groupBy: HighlightsGroupBy) {
        let highlightsVC = buildHighlightsController(groupBy: groupBy)
        navigationCoordinator?.perform(navigation: .push(vc: highlightsVC))
    }
    
    private func buildHighlightsController(groupBy: HighlightsGroupBy) -> UIViewController {
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
        
        highlightsViewController.title = groupBy.title

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
