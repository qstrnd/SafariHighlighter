//
//  CategoryService.swift
//  
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import CoreData

/// This class handles C, U, D in the CRUD for Category objects
public final class CategoryService: NSObject {

    public typealias OperationResult = Result<(), Error>
    public typealias OperationCompletion = (OperationResult) -> Void

    // MARK: - Public

    public init(persistanceExecutor: PersistenceOperationsExecuting) {
        self.persistanceExecutor = persistanceExecutor
    }

    // MARK: Creation

    public func create(category: Category, completion: OperationCompletion? = nil) {
        create(categories: [category], completion: completion)
    }

    public func create(categories: [Category], completion: OperationCompletion? = nil) {
        persistanceExecutor.execute { [unowned self] context in
            categories.forEach { self.create(category: $0, in: context) }

            save(context: context, completion: completion)
        }
    }

    // MARK: Update

    public func update(category: Category, completion: OperationCompletion? = nil) {
        update(categories: [category], completion: completion)
    }

    public func update(categories: [Category], completion: OperationCompletion? = nil) {
        persistanceExecutor.execute { [unowned self] context in
            categories.forEach { self.update(category: $0, in: context) }

            save(context: context, completion: completion)
        }
    }

    // MARK: Deletion

    public func delete(category: Category, completion: OperationCompletion? = nil) {
        delete(categories: [category], completion: completion)
    }

    public func delete(categories: [Category], completion: OperationCompletion? = nil) {
        persistanceExecutor.execute { [unowned self] context in
            categories.forEach { self.delete(category: $0, in: context) }

            save(context: context, completion: completion)
        }
    }

    // MARK: - Internal

    func fetchOrCreatePersistedCategory(for category: Category, in context: NSManagedObjectContext) -> PersistedCategory {
        if let fetchedCategory = fetchPersistedCategory(for: category, in: context) {
            return fetchedCategory
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "PersistedCategory", in: context)!
            return PersistedCategory(entity: entity, insertInto: context)
        }
    }

    // MARK: - Private

    private let persistanceExecutor: PersistenceOperationsExecuting

    // MARK: CRUD

    private func create(category: Category, in context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "PersistedCategory", in: context)!
        let persistedCategory = PersistedCategory(entity: entity, insertInto: context)
        updateProperties(of: persistedCategory, from: category)
    }

    private func update(category: Category, in context: NSManagedObjectContext) {
        let persistedCategory = fetchOrCreatePersistedCategory(for: category, in: context)
        updateProperties(of: persistedCategory, from: category)
    }

    private func delete(category: Category, in context: NSManagedObjectContext) {
        guard let persistedCategory = fetchPersistedCategory(for: category, in: context) else { return }
        context.delete(persistedCategory)
    }

    // MARK: Fetching

    private func fetchPersistedCategory(for category: Category, in context: NSManagedObjectContext) -> PersistedCategory? {
        let fetchRequest = PersistedCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uniqueId == %@", category.uniqueId as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            return nil
        }
    }

    // MARK: Properties Update

    private func updateProperties(of persistedCategory: PersistedCategory, from category: Category) {
        persistedCategory.name = category.name
        persistedCategory.creationDate = category.creationDate
        persistedCategory.uniqueId = category.uniqueId
        persistedCategory.hexColor = category.hexColor
    }

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
