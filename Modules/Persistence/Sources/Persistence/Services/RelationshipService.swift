//
//  RelationshipService.swift
//  
//
//  Created by Andrey Yakovlev on 08.05.2023.
//

import Foundation
import CoreData

public final class RelationshipService: NSObject {

    public typealias OperationResult = Result<(), Error>
    public typealias OperationCompletion = (OperationResult) -> Void

    // MARK: - Public

    public init(
        highlighService: HighlightService,
        categoryService: CategoryService,
        websiteService: WebsiteService,
        persistanceExecutor: persistanceExecutor
    ) {
        self.highlighService = highlighService
        self.categoryService = categoryService
        self.websiteService = websiteService
        self.persistanceExecutor = persistanceExecutor
    }

    public func associate(highlight: Highlight, with category: Category, completion: OperationCompletion? = nil) {
        persistanceExecutor.execute { [unowned self] context in
            let persistedHighlight = highlighService.fetchOrCreatePersistedHighlight(for: highlight, in: context)
            let persistedCategory = categoryService.fetchOrCreatePersistedCategory(for: category, in: context)

            persistedHighlight.category = persistedCategory

            save(context: context, completion: completion)
        }
    }

    public func associate(highlight: Highlight, with website: Website, completion: OperationCompletion? = nil) {
        persistanceExecutor.execute { [unowned self] context in
            let persistedHighlight = highlighService.fetchOrCreatePersistedHighlight(for: highlight, in: context)
            let persistedWebsite = websiteService.fetchOrCreatePersistedWebsite(for: website, in: context)
            
            persistedHighlight.website = persistedWebsite

            save(context: context, completion: completion)
        }
    }

    // MARK: - Private

    private let highlighService: HighlightService
    private let categoryService: CategoryService
    private let websiteService: WebsiteService
    private let persistanceExecutor: persistanceExecutor

    // MARK: Context saving

    private func save(context: NSManagedObjectContext, completion: OperationCompletion? = nil) {
        do {
            if context.hasChanges {
                try context.save()
            }

            completion?(.success(()))
        } catch {
            completion?(.failure(error))
        }
    }

}
