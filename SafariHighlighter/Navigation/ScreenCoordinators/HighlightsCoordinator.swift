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
        persistanceExecutorFactory: persistanceExecutorFactory,
        appStorage: AppStorage
    ) {
        self.persistanceExecutorFactory = persistanceExecutorFactory
        self.appStorage = appStorage
    }
    
    // MARK: - Private
    
    private let persistanceExecutorFactory: persistanceExecutorFactory
    private let appStorage: AppStorage
    private var navigationCoordinator: NavigationCoordinator?
    
    private func buildGroupedHighlightsViewController() -> UIViewController {
        let categoriesVC = buildCategoriesController()
        let websitesVC = buildWebsitesController()
        
        return GroupedHighlightsViewController(groupingVCs: [categoriesVC, websitesVC], appStorage: appStorage)
    }
    
    private func buildCategoriesController() -> CategoriesViewController {
        let sortOrder = CategoryFetchController.Options.SortOrder(rawValue: appStorage.categoriesSortOrderRaw ?? "") ?? .creationDate
        
        let categoryFetchController = CategoryFetchController(
            options: .init(sortOrder: sortOrder, showOnlyCategoriesWithHighlights: false),
            persistanceExecutor: persistanceExecutorFactory.getSharedpersistanceExecutor()
        )
        
        let categoryService = CategoryService(persistanceExecutor: persistanceExecutorFactory.getSharedpersistanceExecutor())
        
        let categoriesViewController = CategoriesViewController(
            appStorage: appStorage,
            categoryFetchController: categoryFetchController,
            categoryService: categoryService,
            highlightsCoordinator: self
        )
        
        return categoriesViewController
    }
    
    private func buildWebsitesController() -> WebsitesViewController {
        let websiteFetchController = WebsiteFetchController(
            options: .init(sortOrder: .creationDate, showOnlyWebsitesWithHighlights: false),
            persistanceExecutor: persistanceExecutorFactory.getSharedpersistanceExecutor()
        )
        
        let websiteService = WebsiteService(persistanceExecutor: persistanceExecutorFactory.getSharedpersistanceExecutor())
        
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
            persistanceExecutor: persistanceExecutorFactory.getSharedpersistanceExecutor()
        )

        let highlightService = HighlightService(persistanceExecutor: persistanceExecutorFactory.getSharedpersistanceExecutor())
        let categoryService = CategoryService(persistanceExecutor: persistanceExecutorFactory.getSharedpersistanceExecutor())
        let websiteService = WebsiteService(persistanceExecutor: persistanceExecutorFactory.getSharedpersistanceExecutor())

        let relationshipService = RelationshipService(
            highlighService: highlightService,
            categoryService: categoryService,
            websiteService: websiteService,
            persistanceExecutor: persistanceExecutorFactory.getSharedpersistanceExecutor()
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
