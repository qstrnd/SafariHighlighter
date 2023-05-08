//
//  HighlightFetchController.swift
//  
//
//  Created by Andrey Yakovlev on 08.05.2023.
//

import CoreData
import Common

public protocol HighlightFetchControllerDelegate: AnyObject {
    func highlightFetchController(_ controller: HighlightFetchController, didUpdateHighlightsAt indexPath: [IndexPath])
    func highlightFetchController(_ controller: HighlightFetchController, didAddHighlights indexPath: [IndexPath])
    func highlightFetchController(_ controller: HighlightFetchController, didDeleteHighlights indexPath: [IndexPath])

    func highlightFetchControllerWillBeginUpdates(_ controller: HighlightFetchController)
    func highlightFetchControllerDidFinishUpdates(_ controller: HighlightFetchController)
}

public final class HighlightFetchController: NSObject {

    // MARK: Nested

    typealias HighlightController = NSFetchedResultsController<PersistedHighlight>

    public struct Options {
        public enum SortOrder {
            case creationDate
            case name

            static let `default` = SortOrder.creationDate
        }

        public enum GroupBy {
            case category(uniqueId: UUID)
            case website(uniqueId: UUID)
        }

        let sortOrder: SortOrder
        let groupBy: GroupBy

        public init(
            sortOrder: HighlightFetchController.Options.SortOrder,
            groupBy: GroupBy
        ) {
            self.sortOrder = sortOrder
            self.groupBy = groupBy
        }
    }

    private enum Constants {
        static let frcCacheName = "com.qstrnd.Persistence.highlightFRCCache"
    }

    // MARK: - Public

    public weak var delegate: HighlightFetchControllerDelegate?

    public var options: Options {
        didSet {
            fetchedResultsController = nil // clean frc configured for old options
            fetchResults()
        }
    }

    public init(
        delegate: HighlightFetchControllerDelegate? = nil,
        options: Options,
        persistanceExecutor: PersistenceOperationsExecuting
    ) {
        self.delegate = delegate
        self.options = options
        self.persistanceExecutor = persistanceExecutor
    }

    public func fetchResults() {
        getFetchResultsController { [weak self] frc in
            guard let self else { return }

            assert(Thread.isMainThread, "Jobs related to frc must be executed on main thread")

            do {
                try frc.performFetch()
            } catch {
                self.handle(error: error)
            }
        }
    }

    public func numberOfHighlights() -> Int {
        precondition(Thread.isMainThread, "Jobs related to frc must be executed on main thread")

        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }

    public func object(at indexPath: IndexPath) -> Highlight {
        precondition(Thread.isMainThread, "Jobs related to frc must be executed on main thread")

        guard let frc = fetchedResultsController else {
            preconditionFailure("Requested the object that wasn't fetched")
        }

        let persitedHighlight = frc.object(at: indexPath)
        let highlight = Highlight(from: persitedHighlight)

        return highlight
    }

    // MARK: - Private

    private let persistanceExecutor: PersistenceOperationsExecuting

    private var fetchedResultsController: HighlightController?

    private func getFetchResultsController(_ completion: @escaping (HighlightController) -> Void) {
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

    private func getFetchRequest() -> NSFetchRequest<PersistedHighlight> {
        let fetchRequest = PersistedHighlight.fetchRequest()

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
        }
    }

    private func getPredicateForCurrentOptions() -> NSPredicate? {
        switch options.groupBy {
        case .category(uniqueId: let uniqueId):
            return NSPredicate(format: "category.uniqueId == %@", uniqueId as CVarArg)
        case .website(uniqueId: let uniqueId):
            return NSPredicate(format: "website.uniqueId == %@", uniqueId as CVarArg)
        }
    }

    // MARK: Error

    private func handle(error: Error) {

    }


}


// MARK: - NSFetchedResultsControllerDelegate
extension HighlightFetchController: NSFetchedResultsControllerDelegate {
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.highlightFetchControllerWillBeginUpdates(self)
    }

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.highlightFetchControllerDidFinishUpdates(self)
    }

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                delegate?.highlightFetchController(self, didAddHighlights: [newIndexPath])
            }
        case .delete:
            if let indexPath = indexPath {
                delegate?.highlightFetchController(self, didDeleteHighlights: [indexPath])
            }
        case .update:
            if let indexPath = indexPath {
                delegate?.highlightFetchController(self, didUpdateHighlightsAt: [indexPath])
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                delegate?.highlightFetchController(self, didDeleteHighlights: [indexPath])
                delegate?.highlightFetchController(self, didAddHighlights: [newIndexPath])
            }
        @unknown default:
            fatalError("Unhandled NSFetchedResultsChangeType")
        }

    }


}


