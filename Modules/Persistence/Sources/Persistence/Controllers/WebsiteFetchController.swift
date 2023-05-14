//
//  WebsiteFetchController.swift
//  
//
//  Created by Andrey Yakovlev on 08.05.2023.
//

import CoreData
import Common

public protocol WebsiteFetchControllerDelegate: AnyObject {
    func websiteFetchController(_ controller: WebsiteFetchController, didUpdateWebsitesAt indexPath: [IndexPath])
    func websiteFetchController(_ controller: WebsiteFetchController, didAddWebsites indexPath: [IndexPath])
    func websiteFetchController(_ controller: WebsiteFetchController, didDeleteWebsites indexPath: [IndexPath])

    func websiteFetchControllerWillBeginUpdates(_ controller: WebsiteFetchController)
    func websiteFetchControllerDidFinishUpdates(_ controller: WebsiteFetchController)
    func websiteFetchControllerDidRequestDataReload(_ controller: WebsiteFetchController)
}

public final class WebsiteFetchController: NSObject {

    // MARK: Nested

    typealias WebsiteController = NSFetchedResultsController<PersistedWebsite>

    public struct Options {
        public enum SortField: String {
            case creationDate
            case name
            case url
            case numberOfHighlights

            static let `default` = SortField.creationDate
        }

        public let sortOrder: SortField
        public let showOnlyWebsitesWithHighlights: Bool
        public let sortOrderAsceding: Bool

        public init(
            sortOrder: WebsiteFetchController.Options.SortField,
            sortOrderAsceding: Bool,
            showOnlyWebsitesWithHighlights: Bool = false
        ) {
            self.sortOrder = sortOrder
            self.sortOrderAsceding = sortOrderAsceding
            self.showOnlyWebsitesWithHighlights = showOnlyWebsitesWithHighlights
        }
    }

    // MARK: - Public

    public weak var delegate: WebsiteFetchControllerDelegate?

    public var options: Options {
        didSet {
            fetchedResultsController = nil // clean frc configured for old options
            _fetchedObjectsSortedByNumberOfHighlights = []
        }
    }
    
    public func updateOptions(_ newOptions: Options, completion:  (() -> Void)? = nil) {
        options = newOptions
        fetchResults(completion)
    }

    public init(
        delegate: WebsiteFetchControllerDelegate? = nil,
        options: Options,
        persistanceExecutor: PersistenceOperationsExecuting
    ) {
        self.delegate = delegate
        self.options = options
        self.persistanceExecutor = persistanceExecutor
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

    public func numberOfWebsites() -> Int {
        precondition(Thread.isMainThread, "Jobs related to frc must be executed on main thread")

        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }

    public func object(at indexPath: IndexPath) -> Website {
        precondition(Thread.isMainThread, "Jobs related to frc must be executed on main thread")

        guard let frc = fetchedResultsController else {
            preconditionFailure("Requested the object that wasn't fetched")
        }
        
        let persistedWebsite: PersistedWebsite
        switch options.sortOrder {
        case .numberOfHighlights:
            persistedWebsite = fetchedObjectsSortedByNumberOfHighlights[indexPath.row]
        default:
            persistedWebsite = frc.object(at: indexPath)
        }

        let website = Website(from: persistedWebsite)

        return website
    }

    // MARK: - Private

    private let persistanceExecutor: PersistenceOperationsExecuting

    private var fetchedResultsController: WebsiteController?
    
    private var isFullReloadUpdateInProgress = false
    
    private var _fetchedObjectsSortedByNumberOfHighlights: [PersistedWebsite] = []
    
    /// Sorting with aggregate functions is not supported in mysql :(
    /// That's why this property is used to store objects that are sorted AFTER fetch
    private var fetchedObjectsSortedByNumberOfHighlights: [PersistedWebsite] {
        guard _fetchedObjectsSortedByNumberOfHighlights.isEmpty else {
            return _fetchedObjectsSortedByNumberOfHighlights
        }
        
        guard let frc = fetchedResultsController else {
            preconditionFailure("Requested sorted objects before fetch was performed")
        }
        
        let sortClosure: (PersistedWebsite, PersistedWebsite) -> Bool
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

    private func getFetchResultsController(_ completion: @escaping (WebsiteController) -> Void) {
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

    private func getFetchRequest() -> NSFetchRequest<PersistedWebsite> {
        let fetchRequest = PersistedWebsite.fetchRequest()

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
        case .url:
            return NSSortDescriptor(key: "url", ascending: options.sortOrderAsceding)
        }
    }

    private func getPredicateForCurrentOptions() -> NSPredicate? {
        guard options.showOnlyWebsitesWithHighlights else { return nil }

        return NSPredicate(format: "highlights.@count > 0")
    }

    // MARK: Error

    private func handle(error: Error) {

    }


}


// MARK: - NSFetchedResultsControllerDelegate
extension WebsiteFetchController: NSFetchedResultsControllerDelegate {
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if options.sortOrder == .numberOfHighlights {
            isFullReloadUpdateInProgress = true
        } else {
            delegate?.websiteFetchControllerWillBeginUpdates(self)
        }
    }

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if isFullReloadUpdateInProgress {
            delegate?.websiteFetchControllerDidRequestDataReload(self)
            
            isFullReloadUpdateInProgress = false
            _fetchedObjectsSortedByNumberOfHighlights = []
        } else {
            delegate?.websiteFetchControllerDidFinishUpdates(self)
        }
    }

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard !isFullReloadUpdateInProgress else { return }

        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                delegate?.websiteFetchController(self, didAddWebsites: [newIndexPath])
            }
        case .delete:
            if let indexPath = indexPath {
                delegate?.websiteFetchController(self, didDeleteWebsites: [indexPath])
            }
        case .update:
            if let indexPath = indexPath {
                delegate?.websiteFetchController(self, didUpdateWebsitesAt: [indexPath])
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                delegate?.websiteFetchController(self, didDeleteWebsites: [indexPath])
                delegate?.websiteFetchController(self, didAddWebsites: [newIndexPath])
            }
        @unknown default:
            fatalError("Unhandled NSFetchedResultsChangeType")
        }

    }


}

