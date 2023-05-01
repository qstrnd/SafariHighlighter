//
//  PersistentContainer.swift
//
//
//  Created by Andrey Yakovlev on 22.04.2023.
//

import Foundation
import CoreData
import Common

/// Manager responsible for setting up the persistent container and reload it with appropriate options
final class PersistentManager {

    // MARK: - Nested

    enum StoreLoadingState {
        case notLoaded
        case loading
        case loaded
    }

    enum Constants {
        static let name = "HighlightDataModel"
        static let cloudKitContainerId = "\(Bundle.main.bundleIdentifier!).CloutKit"
    }

    typealias LoadingResult = Result<(), Error>

    // MARK: - Internal

    /// Options for underlying persistent store
    ///
    /// Each time this property is changed, reloading of the store is performed
    var storeOptions: PersistentStoreOptions {
        didSet {
            loadPersistentStore()
        }
    }

    init(
        storeOptions: PersistentStoreOptions,
        loadPersistentStoreImmediately: Bool
    ) {
        self.storeOptions = storeOptions

        if loadPersistentStoreImmediately {
            loadPersistentStore()
        }
    }

    /// Load the underlying persistent store
    /// - Parameter completion: The job should be executed after the loading has been completed. If it is successful, it is executed before any jobs scheduled to be performed with the managed object context. In case of failure, it is executed before any error handling.
    func loadPersistentStore(_ completion: ((LoadingResult) -> Void)? = nil) {
        storeLoadingState = .loading

        let storeDescription = createConfiguredPersistentStoreDescription()
        container.persistentStoreDescriptions = [storeDescription]

        container.loadPersistentStores { [weak self] loadedStoreDescription, error in
            guard let self else { return }

            if let error = error {
                self.storeLoadingState = .notLoaded
                completion?(.failure(error))
                self.handle(loadingError: error)
                return
            }

            self.storeLoadingState = .loaded
            completion?(.success(()))

            self.operationQueueLock.lock()
            self.operationQueue.forEach { $0() }
            self.operationQueue.removeAll()
            self.operationQueueLock.unlock()

            Logger.persistence.log(
                "Loaded persistent store. Type: %@, url: %@, options: %@, cloudOptions: %@",
                loadedStoreDescription.type,
                loadedStoreDescription.url,
                loadedStoreDescription.options,
                loadedStoreDescription.cloudKitContainerOptions
            )
        }
    }

    /// Execute the given block on the appropriate context immdiately or schecule its execution if store is not yet loaded
    ///
    /// This method is thread safe
    /// - Parameter block: block of code
    func execute(_ block: @escaping (NSManagedObjectContext) -> Void) {
        switch storeLoadingState {
        case .loaded:
            executeOnCurrentThread(block)
        case .loading, .notLoaded:
            Logger.persistence.log("Scheduled persistence-related operation", type: .info)
            let isRequestedOnMainThread = Thread.isMainThread

            operationQueueLock.lock()
            operationQueue.append { [weak self] in
                self?.execute(onMainThread: isRequestedOnMainThread, block)
            }
            operationQueueLock.unlock()
        }
    }

    // MARK: - Private

    private var storeLoadingState: StoreLoadingState = .notLoaded

    /// The queue is used to schedule tasks that are dispatched before the store is loaded.
    /// - Important: Since dispatches can be requested from different threads, use the lock to access and modify the queue
    private var operationQueue: [() -> Void] = []
    private let operationQueueLock = NSLock()

    private lazy var container: NSPersistentCloudKitContainer = {
        guard let momdUrl = Bundle.module.url(forResource: Constants.name, withExtension: "momd") else {
            fatalError("No momd file for \(Constants.name); in module: \(Bundle.module)")
        }

        guard let objectModel = NSManagedObjectModel(contentsOf: momdUrl) else {
            fatalError("Error initializing object model with the contents of \(momdUrl)")
        }

        return NSPersistentCloudKitContainer(name: Constants.name, managedObjectModel: objectModel)
    }()

    private var storeUrl: URL {
        guard storeOptions.isPersistenceEnabled else { return URL(string: "/dev/null")! }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let storeFileName = "\(Constants.name).sqlite"

        return documentsDirectory.appendingPathComponent(storeFileName)
    }

    private func createConfiguredPersistentStoreDescription() -> NSPersistentStoreDescription {
        let storeDescription = NSPersistentStoreDescription(url: storeUrl)

        storeDescription.shouldMigrateStoreAutomatically = true
        storeDescription.shouldInferMappingModelAutomatically = true

        if storeOptions.isCloudSyncEnabled {
            storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: Constants.cloudKitContainerId)
        }

        storeDescription.type = storeOptions.isPersistenceEnabled ? NSSQLiteStoreType : NSInMemoryStoreType

        return storeDescription
    }

    private func executeOnCurrentThread(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.getContextForCurrentThread()
        performBlock(on: context, block)
    }

    private func getContextForCurrentThread() -> NSManagedObjectContext {
        if Thread.isMainThread {
            return container.viewContext
        } else {
            return container.newBackgroundContext()
        }
    }

    private func execute(onMainThread: Bool, _ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.getContext(mainThread: onMainThread)
        performBlock(on: context, block)
    }

    private func getContext(mainThread: Bool) -> NSManagedObjectContext {
        mainThread ? container.viewContext : container.newBackgroundContext()
    }

    private func performBlock(on context: NSManagedObjectContext, _ block: @escaping (NSManagedObjectContext) -> Void) {
        context.perform {
            Logger.persistence.log("Perform persistence-related operation on thread: %@", type: .info, Thread.current.name)
            block(context)
        }
    }

    private func handle(loadingError: Error) {

    }

}
