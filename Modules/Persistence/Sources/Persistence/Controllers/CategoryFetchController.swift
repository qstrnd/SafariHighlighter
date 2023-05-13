//
//  CategoryFetchController.swift
//  
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import CoreData
import Common

public protocol CategoryFetchControllerDelegate: AnyObject {
    func categoryFetchController(_ controller: CategoryFetchController, didUpdateCategoriesAt indexPath: [IndexPath])
    func categoryFetchController(_ controller: CategoryFetchController, didAddCategories indexPath: [IndexPath])
    func categoryFetchController(_ controller: CategoryFetchController, didDeleteCategories indexPath: [IndexPath])

    func categoryFetchControllerWillBeginUpdates(_ controller: CategoryFetchController)
    func categoryFetchControllerDidFinishUpdates(_ controller: CategoryFetchController)
    func categoryFetchControllerDidRequestDataReload(_ controller: CategoryFetchController)
}

public final class CategoryFetchController: NSObject {

    // MARK: Nested

    typealias CategoryController = NSFetchedResultsController<PersistedCategory>

    public struct Options {
        public enum SortField: String {
            case creationDate
            case name
            case numberOfHighlights

            static let `default` = SortField.creationDate
        }

        public let sortOrder: SortField
        public let sortOrderAsceding: Bool
        public let showOnlyCategoriesWithHighlights: Bool

        public init(
            sortOrder: CategoryFetchController.Options.SortField,
            sortOrderAsceding: Bool,
            showOnlyCategoriesWithHighlights: Bool = false
        ) {
            self.sortOrder = sortOrder
            self.sortOrderAsceding = sortOrderAsceding
            self.showOnlyCategoriesWithHighlights = showOnlyCategoriesWithHighlights
        }
    }

    // MARK: - Public

    public weak var delegate: CategoryFetchControllerDelegate?

    public private(set) var options: Options {
        didSet {
            fetchedResultsController = nil // clean frc configured for old options
            _fetchedObjectsSortedByNumberOfHighlights = []
        }
    }

    public init(
        delegate: CategoryFetchControllerDelegate? = nil,
        options: Options,
        persistanceExecutor: PersistenceOperationsExecuting
    ) {
        self.delegate = delegate
        self.options = options
        self.persistanceExecutor = persistanceExecutor
    }
    
    public func updateOptions(_ newOptions: Options, completion:  (() -> Void)? = nil) {
        options = newOptions
        fetchResults(completion)
    }

    public func fetchResults(_ completion: (() -> Void)? = nil) {
        getFetchResultsController { [weak self] frc in
            guard let self else { return }

            assert(Thread.isMainThread, "Jobs related to frc must be executed on main thread")

            do {
                try frc.performFetch()

                completion?()
            } catch {
                self.handle(error: error)
            }
        }
    }

    public func numberOfCategories() -> Int {
        precondition(Thread.isMainThread, "Jobs related to frc must be executed on main thread")

        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }

    public func object(at indexPath: IndexPath) -> Category {
        precondition(Thread.isMainThread, "Jobs related to frc must be executed on main thread")

        guard let frc = fetchedResultsController else {
            preconditionFailure("Requested the object that wasn't fetched")
        }
        
        let persitedCategory: PersistedCategory
        switch options.sortOrder {
        case .numberOfHighlights:
            persitedCategory = fetchedObjectsSortedByNumberOfHighlights[indexPath.row]
        default:
            persitedCategory = frc.object(at: indexPath)
        }

        let category = Category(from: persitedCategory)

        return category
    }

    // MARK: - Private

    private let persistanceExecutor: PersistenceOperationsExecuting

    private var fetchedResultsController: CategoryController?
    
    private var isFullReloadUpdateInProgress = false
    
    private var _fetchedObjectsSortedByNumberOfHighlights: [PersistedCategory] = []
    
    /// Sorting with aggregate functions is not supported in mysql :(
    /// That's why this property is used to store objects that are sorted AFTER fetch
    private var fetchedObjectsSortedByNumberOfHighlights: [PersistedCategory] {
        guard _fetchedObjectsSortedByNumberOfHighlights.isEmpty else {
            return _fetchedObjectsSortedByNumberOfHighlights
        }
        
        guard let frc = fetchedResultsController else {
            preconditionFailure("Requested sorted objects before fetch was performed")
        }
        
        let sortClosure: (PersistedCategory, PersistedCategory) -> Bool
        if options.sortOrderAsceding {
            sortClosure = {
                $0.highlights?.count ?? 0 < $1.highlights?.count ?? 0
            }
        } else {
            sortClosure = {
                $0.highlights?.count ?? 0 > $1.highlights?.count ?? 0
            }
        }
        
        _fetchedObjectsSortedByNumberOfHighlights = frc.fetchedObjects?.sorted(by: sortClosure) ?? []
        
        return _fetchedObjectsSortedByNumberOfHighlights
    }

    private func getFetchResultsController(_ completion: @escaping (CategoryController) -> Void) {
        DispatchQueue.performOnMain {
            if let frc = self.fetchedResultsController {
                completion(frc); return
            }

            self.persistanceExecutor.execute { [weak self] context in
                guard let self else { return }

                assert(Thread.isMainThread, "Jobs related to frc must be executed on main thread")

                let frc = NSFetchedResultsController(
                    fetchRequest: self.getFetchRequest(),
                    managedObjectContext: context,
                    sectionNameKeyPath: nil,
                    cacheName: nil
                )

                frc.delegate = self

                self.fetchedResultsController = frc

                completion(frc)
            }
        }
    }

    // MARK: Fetching

    private func getFetchRequest() -> NSFetchRequest<PersistedCategory> {
        let fetchRequest = PersistedCategory.fetchRequest()

        let sortDescriptor = getSortDescriptorForCurrentOptions()
        fetchRequest.sortDescriptors = [sortDescriptor]

        if let predicate = getPredicateForCurrentOptions() {
            fetchRequest.predicate = predicate
        }

        return fetchRequest
    }

    private func getSortDescriptorForCurrentOptions() -> NSSortDescriptor {
        switch options.sortOrder {
        case .creationDate, .numberOfHighlights:
            return NSSortDescriptor(key: "creationDate", ascending: options.sortOrderAsceding)
        case .name:
            return NSSortDescriptor(key: "name", ascending: options.sortOrderAsceding)
        }
    }

    private func getPredicateForCurrentOptions() -> NSPredicate? {
        guard options.showOnlyCategoriesWithHighlights else { return nil }

        return NSPredicate(format: "highlights.@count > 0")
    }

    // MARK: Error

    private func handle(error: Error) {

    }


}


// MARK: - NSFetchedResultsControllerDelegate
extension CategoryFetchController: NSFetchedResultsControllerDelegate {
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if options.sortOrder == .numberOfHighlights {
            isFullReloadUpdateInProgress = true
        }
        delegate?.categoryFetchControllerWillBeginUpdates(self)
    }

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if isFullReloadUpdateInProgress {
            delegate?.categoryFetchControllerDidRequestDataReload(self)
            
            isFullReloadUpdateInProgress = false
            _fetchedObjectsSortedByNumberOfHighlights = []
        }
        delegate?.categoryFetchControllerDidFinishUpdates(self)
    }

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard !isFullReloadUpdateInProgress else { return }

        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                delegate?.categoryFetchController(self, didAddCategories: [newIndexPath])
            }
        case .delete:
            if let indexPath = indexPath {
                delegate?.categoryFetchController(self, didDeleteCategories: [indexPath])
            }
        case .update:
            if let indexPath = indexPath {
                delegate?.categoryFetchController(self, didUpdateCategoriesAt: [indexPath])
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                delegate?.categoryFetchController(self, didDeleteCategories: [indexPath])
                delegate?.categoryFetchController(self, didAddCategories: [newIndexPath])
            }
        @unknown default:
            fatalError("Unhandled NSFetchedResultsChangeType")
        }

    }


}

