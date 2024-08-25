//
//  LaunchManager.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation

class LaunchManager {
    private let launchedBeforeKey = "hasLaunchedBefore"

    static let shared = LaunchManager()

    private init() {}

    var isFirstLaunch: Bool {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: launchedBeforeKey)
        if hasLaunchedBefore {
            return false
        } else {
            UserDefaults.standard.set(true, forKey: launchedBeforeKey)
            return true
        }
    }
}
