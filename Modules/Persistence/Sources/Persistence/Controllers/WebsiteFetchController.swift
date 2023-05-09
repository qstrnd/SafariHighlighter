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
}

public final class WebsiteFetchController: NSObject {

    // MARK: Nested

    typealias WebsiteController = NSFetchedResultsController<PersistedWebsite>

    public struct Options {
        public enum SortOrder {
            case creationDate
            case name
            case url

            static let `default` = SortOrder.creationDate
        }

        let sortOrder: SortOrder
        let showOnlyWebsitesWithHighlights: Bool

        public init(
            sortOrder: WebsiteFetchController.Options.SortOrder,
            showOnlyWebsitesWithHighlights: Bool
        ) {
            self.sortOrder = sortOrder
            self.showOnlyWebsitesWithHighlights = showOnlyWebsitesWithHighlights
        }
    }

    private enum Constants {
        static let frcCacheName = "com.qstrnd.Persistence.websiteFRCCache"
    }

    // MARK: - Public

    public weak var delegate: WebsiteFetchControllerDelegate?

    public var options: Options {
        didSet {
            fetchedResultsController = nil // clean frc configured for old options
            fetchResults()
        }
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

        let persitedWebsite = frc.object(at: indexPath)
        let website = Website(from: persitedWebsite)

        return website
    }

    // MARK: - Private

    private let persistanceExecutor: PersistenceOperationsExecuting

    private var fetchedResultsController: WebsiteController?

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
                    cacheName: Constants.frcCacheName
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
        case .creationDate:
            return NSSortDescriptor(key: "creationDate", ascending: true)
        case .name:
            return NSSortDescriptor(key: "name", ascending: true)
        case .url:
            return NSSortDescriptor(key: "url", ascending: true)
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
        delegate?.websiteFetchControllerWillBeginUpdates(self)
    }

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.websiteFetchControllerDidFinishUpdates(self)
    }

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

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

