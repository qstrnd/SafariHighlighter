//
//  HighlightSevice.swift
//  
//
//  Created by Andrey Yakovlev on 08.05.2023.
//

import CoreData

/// This class handles C, U, D in the CRUD for Highlight objects
public final class HighlightService: NSObject {

    public typealias OperationResult = Result<(), Error>
    public typealias OperationCompletion = (OperationResult) -> Void

    // MARK: - Public

    public init(persistanceExecutor: PersistenceOperationsExecuting) {
        self.persistanceExecutor = persistanceExecutor
    }

    // MARK: Creation

    public func create(highlight: Highlight, completion: OperationCompletion? = nil) {
        create(highlights: [highlight], completion: completion)
    }

    public func create(highlights: [Highlight], completion: OperationCompletion? = nil) {
        persistanceExecutor.execute { [unowned self] context in
            highlights.forEach { self.create(highlight: $0, in: context) }

            save(context: context, completion: completion)
        }
    }

    // MARK: Update

    public func update(highlight: Highlight, completion: OperationCompletion? = nil) {
        update(highlights: [highlight], completion: completion)
    }

    public func update(highlights: [Highlight], completion: OperationCompletion? = nil) {
        persistanceExecutor.execute { [unowned self] context in
            highlights.forEach { self.update(highlight: $0, in: context) }

            save(context: context, completion: completion)
        }
    }

    // MARK: Deletion

    public func delete(highlight: Highlight, completion: OperationCompletion? = nil) {
        delete(highlights: [highlight], completion: completion)
    }

    public func delete(highlights: [Highlight], completion: OperationCompletion? = nil) {
        persistanceExecutor.execute { [unowned self] context in
            highlights.forEach { self.delete(highlight: $0, in: context) }

            save(context: context, completion: completion)
        }
    }

    // MARK: - Internal

    func fetchOrCreatePersistedHighlight(for highlight: Highlight, in context: NSManagedObjectContext) -> PersistedHighlight {
        if let fetchedHighlight = fetchPersistedHighlight(for: highlight, in: context) {
            return fetchedHighlight
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "PersistedHighlight", in: context)!
            return PersistedHighlight(entity: entity, insertInto: context)
        }
    }

    // MARK: - Private

    private let persistanceExecutor: PersistenceOperationsExecuting

    // MARK: CRUD

    private func create(highlight: Highlight, in context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "PersistedHighlight", in: context)!
        let persistedHighlight = PersistedHighlight(entity: entity, insertInto: context)
        updateProperties(of: persistedHighlight, from: highlight)
    }

    private func update(highlight: Highlight, in context: NSManagedObjectContext) {
        let persistedHighlight = fetchOrCreatePersistedHighlight(for: highlight, in: context)
        updateProperties(of: persistedHighlight, from: highlight)
    }

    private func delete(highlight: Highlight, in context: NSManagedObjectContext) {
        guard let persistedHighlight = fetchPersistedHighlight(for: highlight, in: context) else { return }
        context.delete(persistedHighlight)
    }

    // MARK: Fetching

    private func fetchPersistedHighlight(for highlight: Highlight, in context: NSManagedObjectContext) -> PersistedHighlight? {
        let fetchRequest = PersistedHighlight.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uniqueId == %@", highlight.uniqueId as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            return nil
        }
    }

    // MARK: Properties Update

    private func updateProperties(of persistedHighlight: PersistedHighlight, from highlight: Highlight) {
        persistedHighlight.text = highlight.text
        persistedHighlight.location = highlight.location
        persistedHighlight.creationDate = highlight.creationDate
        persistedHighlight.uniqueId = highlight.uniqueId
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
