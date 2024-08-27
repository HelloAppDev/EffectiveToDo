//
//  TodosUnitTest.swift
//  EffectiveToDoTests
//
//  Created by Мария Изюменко on 28.08.2024.
//

import XCTest
@testable import EffectiveToDo

class TodoTests: XCTestCase {

    // MARK: Equal todos

    func test_TodosAreEqual() {
        let todo1 = Todo(id: 1, title: "Task 1", subtitle: "Subtitle 1", createdAt: Date(), isCompleted: false)
        let todo2 = Todo(id: 2, title: "Task 1", subtitle: "Subtitle 1", createdAt: Date(), isCompleted: false)

        let areEqual = todo1 == todo2

        XCTAssertTrue(areEqual)
    }

    // MARK: Not equal todos

    func test_TodosAreNotEqual() {
        let todo1 = Todo(id: 1, title: "Task 1", subtitle: "Subtitle 1", createdAt: Date(), isCompleted: false)
        let todo2 = Todo(id: 2, title: "Task 2", subtitle: "Subtitle 2", createdAt: Date(), isCompleted: true)
        
        let areEqual = todo1 == todo2
        
        XCTAssertFalse(areEqual)
    }

    // MARK: Different isCompleted

    func test_TodosAreNotEqualWithDifferentCompletionStatus() {
        let todo1 = Todo(id: 1, title: "Task 1", subtitle: "Subtitle 1", createdAt: Date(), isCompleted: false)
        let todo2 = Todo(id: 2, title: "Task 1", subtitle: "Subtitle 1", createdAt: Date(), isCompleted: true)

        let areEqual = todo1 == todo2

        XCTAssertFalse(areEqual)
    }

    // MARK: Equal nil properties

    func test_TodosAreEqualWithNilSubtitles() {
        let todo1 = Todo(id: 1, title: "Task 1", subtitle: nil, createdAt: Date(), isCompleted: false)
        let todo2 = Todo(id: 2, title: "Task 1", subtitle: nil, createdAt: Date(), isCompleted: false)

        let areEqual = todo1 == todo2

        XCTAssertTrue(areEqual)
    }

    // MARK: One nil property

    func test_TodosAreNotEqualWithOneNilSubtitle() {
        let todo1 = Todo(id: 1, title: "Task 1", subtitle: nil, createdAt: Date(), isCompleted: false)
        let todo2 = Todo(id: 2, title: "Task 1", subtitle: "Subtitle 1", createdAt: Date(), isCompleted: false)

        let areEqual = todo1 == todo2

        XCTAssertFalse(areEqual)
    }
}

