//
//  CategoryService.swift
//  
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import CoreData

final class CategoryService: NSObject {

    typealias OperationResult = Result<(), Error>
    typealias OperationCompletion = (OperationResult) -> Void

    // MARK: - Internal

    init(persistentManager: PersistentManager) {
        self.persistentManager = persistentManager
    }

    // MARK: Creation

    func create(category: Category, completion: OperationCompletion? = nil) {
        create(categories: [category], completion: completion)
    }

    func create(categories: [Category], completion: OperationCompletion? = nil) {
        persistentManager.execute { [unowned self] context in
            categories.forEach { self.create(category: $0, in: context) }

            save(context: context)
        }
    }

    // MARK: Read

    // MARK: Update

    func update(category: Category, completion: OperationCompletion? = nil) {
        update(categories: [category], completion: completion)
    }

    func update(categories: [Category], completion: OperationCompletion? = nil) {
        persistentManager.execute { [unowned self] context in
            categories.forEach { self.update(category: $0, in: context) }

            save(context: context)
        }
    }

    // MARK: Deletion

    func delete(category: Category, completion: OperationCompletion? = nil) {
        delete(categories: [category], completion: completion)
    }

    func delete(categories: [Category], completion: OperationCompletion? = nil) {
        persistentManager.execute { [unowned self] context in
            categories.forEach { self.delete(category: $0, in: context) }

            save(context: context)
        }
    }

    // MARK: - Private

    private let persistentManager: PersistentManager

    // MARK: CRUD

    private func create(category: Category, in context: NSManagedObjectContext) {
        let persistedCategory = PersistedCategory(context: context)
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

    private func fetchOrCreatePersistedCategory(for category: Category, in context: NSManagedObjectContext) -> PersistedCategory {
        if let fetchedCategory = fetchPersistedCategory(for: category, in: context) {
            return fetchedCategory
        } else {
            return PersistedCategory(context: context)
        }
    }

    // MARK: Properties Update

    private func updateProperties(of persistedCategory: PersistedCategory, from category: Category) {
        persistedCategory.name = category.name
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
