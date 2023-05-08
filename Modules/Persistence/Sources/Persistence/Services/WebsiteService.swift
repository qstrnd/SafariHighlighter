//
//  WebsiteService.swift
//  
//
//  Created by Andrey Yakovlev on 08.05.2023.
//

import CoreData

/// This class handles C, U, D in the CRUD for Website objects
public final class WebsiteService: NSObject {

    public typealias OperationResult = Result<(), Error>
    public typealias OperationCompletion = (OperationResult) -> Void

    // MARK: - Public

    public init(persistanceExecutor: PersistenceOperationsExecuting) {
        self.persistanceExecutor = persistanceExecutor
    }

    // MARK: Creation

    public func create(website: Website, completion: OperationCompletion? = nil) {
        create(websites: [website], completion: completion)
    }

    public func create(websites: [Website], completion: OperationCompletion? = nil) {
        persistanceExecutor.execute { [unowned self] context in
            websites.forEach { self.create(website: $0, in: context) }

            save(context: context, completion: completion)
        }
    }

    // MARK: Update

    public func update(website: Website, completion: OperationCompletion? = nil) {
        update(websites: [website], completion: completion)
    }

    public func update(websites: [Website], completion: OperationCompletion? = nil) {
        persistanceExecutor.execute { [unowned self] context in
            websites.forEach { self.update(website: $0, in: context) }

            save(context: context, completion: completion)
        }
    }

    // MARK: Deletion

    public func delete(website: Website, completion: OperationCompletion? = nil) {
        delete(websites: [website], completion: completion)
    }

    public func delete(websites: [Website], completion: OperationCompletion? = nil) {
        persistanceExecutor.execute { [unowned self] context in
            websites.forEach { self.delete(website: $0, in: context) }

            save(context: context, completion: completion)
        }
    }

    // MARK: - Internal

    func fetchOrCreatePersistedWebsite(for website: Website, in context: NSManagedObjectContext) -> PersistedWebsite {
        if let fetchedWebsite = fetchPersistedWebsite(for: website, in: context) {
            return fetchedWebsite
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "PersistedWebsite", in: context)!
            return PersistedWebsite(entity: entity, insertInto: context)
        }
    }

    // MARK: - Private

    private let persistanceExecutor: PersistenceOperationsExecuting

    // MARK: CRUD

    private func create(website: Website, in context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "PersistedWebsite", in: context)!
        let persistedWebsite = PersistedWebsite(entity: entity, insertInto: context)
        updateProperties(of: persistedWebsite, from: website)
    }

    private func update(website: Website, in context: NSManagedObjectContext) {
        let persistedWebsite = fetchOrCreatePersistedWebsite(for: website, in: context)
        updateProperties(of: persistedWebsite, from: website)
    }

    private func delete(website: Website, in context: NSManagedObjectContext) {
        guard let persistedWebsite = fetchPersistedWebsite(for: website, in: context) else { return }
        context.delete(persistedWebsite)
    }

    // MARK: Fetching

    private func fetchPersistedWebsite(for website: Website, in context: NSManagedObjectContext) -> PersistedWebsite? {
        let fetchRequest = PersistedWebsite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uniqueId == %@", website.uniqueId as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            return nil
        }
    }

    // MARK: Properties Update

    private func updateProperties(of persistedWebsite: PersistedWebsite, from website: Website) {
        persistedWebsite.name = website.name
        persistedWebsite.url = website.url.absoluteString
        persistedWebsite.creationDate = website.creationDate
        persistedWebsite.uniqueId = website.uniqueId
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
