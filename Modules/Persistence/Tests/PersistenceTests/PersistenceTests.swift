import XCTest
import CoreData
@testable import Persistence

final class PersistenceManagerTests: XCTestCase {

    private enum Constants {
        static let defaultPersistentStoreOptions = PersistentStoreOptions(
            isPersistenceEnabled: false,
            isCloudSyncEnabled: false
        )
    }

    private var sut: PersistentManager!

    private let backgroundDispatchQueue = DispatchQueue(label: "com.qstrnd.backgroundQueue", qos: .userInteractive)

    override func setUp() {
        super.setUp()
        sut = PersistentManager(
            storeOptions: Constants.defaultPersistentStoreOptions,
            loadPersistentStoreImmediately: false
        )
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testStoreIsLoaded() {
        let storeLoaded = XCTestExpectation(description: "Loading is completed")
        var isStoreLoaded = false

        sut.loadPersistentStore { result in
            guard case .success = result else {
                storeLoaded.fulfill(); return
            }

            isStoreLoaded = true
            storeLoaded.fulfill()
        }

        wait(for: [storeLoaded], timeout: 5.0)
        XCTAssertTrue(isStoreLoaded, "Error loading core data store")
    }

    func testBlocksAreExecutedAfterSuccessfulLoading() {
        let blockExecuted = XCTestExpectation(description: "Block is executed")
        var isStoreLoaded = false

        sut.execute { _ in
            XCTAssertTrue(isStoreLoaded, "The block is executed before the store has been loaded")
            blockExecuted.fulfill()
        }

        sut.loadPersistentStore { result in
            isStoreLoaded = true
        }

        wait(for: [blockExecuted], timeout: 5.0)
    }

    func testBlockIsExecutedOnTheThreadItWasCalledOn() {
        let blocksExecuted = XCTestExpectation(description: "Block is executed")
        blocksExecuted.expectedFulfillmentCount = 2

        // Requested on background queue
        backgroundDispatchQueue.async {
            self.sut.execute { _ in
                XCTAssertFalse(Thread.isMainThread, "Thread execution that is requested on background thread is not performed in background")
                blocksExecuted.fulfill()
            }
        }

        // Requested on main queue
        sut.execute { _ in
            XCTAssertTrue(Thread.isMainThread, "Thread execution that is requested on main thread is not performed on it")
            blocksExecuted.fulfill()
        }

        sut.loadPersistentStore()

        wait(for: [blocksExecuted], timeout: 5.0)
    }
}
