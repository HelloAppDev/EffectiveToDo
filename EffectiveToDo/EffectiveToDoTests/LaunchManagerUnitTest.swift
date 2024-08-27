//
//  LaunchManagerUnitTest.swift
//  EffectiveToDoTests
//
//  Created by Мария Изюменко on 28.08.2024.
//


import XCTest
@testable import EffectiveToDo

class LaunchManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
        super.tearDown()
    }

    func testIsFirstLaunch_FirstLaunch_ReturnsTrue() {
        let launchManager = LaunchManager.shared

        let isFirstLaunch = launchManager.isFirstLaunch

        XCTAssertTrue(isFirstLaunch)
    }

    func testIsFirstLaunch_SecondLaunch_ReturnsFalse() {
        let launchManager = LaunchManager.shared

        _ = launchManager.isFirstLaunch
        let isFirstLaunchSecondCall = launchManager.isFirstLaunch

        XCTAssertFalse(isFirstLaunchSecondCall)
    }
}
