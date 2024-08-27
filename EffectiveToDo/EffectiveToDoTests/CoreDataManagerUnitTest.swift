//
//  CoreDataManagerUnitTest.swift
//  EffectiveToDoTests
//
//  Created by Мария Изюменко on 28.08.2024.
//

import XCTest
import CoreData
@testable import EffectiveToDo

class CoreDataManagerTests: XCTestCase {
    var coreDataManager: CoreDataManager!

    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
        setupInMemoryPersistentContainer()
    }

    override func tearDown() {
        coreDataManager = nil
        super.tearDown()
    }

    // MARK: - Set in-memory persistent container

    private func setupInMemoryPersistentContainer() {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: "EffectiveToDo")
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { storeDescription, error in
            XCTAssertNil(error)
        }

        coreDataManager.persistentContainer = container
    }

    // MARK: - Tests

    func test_PersistentContainerInitialization() {
        let context = coreDataManager.context
        XCTAssertNotNil(context, "context != nil")
    }

    func test_SaveContextWithChanges() {
        let context = coreDataManager.context
        let entity = NSEntityDescription.insertNewObject(forEntityName: "TodoDBO", into: context)
        entity.setValue(1, forKey: "id")
        entity.setValue("task title", forKey: "title")
        entity.setValue(Date(), forKey: "createdAt")
        coreDataManager.saveContext()
        XCTAssertFalse(context.hasChanges, "context not changed")
    }

    func test_SaveContextWithoutChanges() {
        let context = coreDataManager.context
        coreDataManager.saveContext()
        XCTAssertFalse(context.hasChanges, "context not changed")
    }

    func test_ContextHasChangesAfterInsertion() {
        let context = coreDataManager.context
        NSEntityDescription.insertNewObject(forEntityName: "TodoDBO", into: context)
        XCTAssertTrue(context.hasChanges, "refresh context")
    }
}
