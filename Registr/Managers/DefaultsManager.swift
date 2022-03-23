//
//  DefaultsManager.swift
//  Registr
//
//  Created by Simon Andersen on 23/03/2022.
//

import Foundation

final class DefaultsManager {
    static let shared = DefaultsManager()
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    private enum Key: String {
        case currentProfileID = "DefaultsManager_currentProfileID"
        case favorites = "DefaultsManager_favorites"
        case localDataManagerDatabaseVersion = "DefaultsManager_localDataManagerDatabaseVersion"
        case language = "DefaultsManager_language"
        case lastRemoteDataCompleteSync = "DefaultsManager_lastRemoteDataCompleteSync"
        case onboardingCompleted = "DefaultsManager_onboardingCompleted"
        case feedOrder = "DefaultsManager_feedOrder"
    }
    
    // MARK: - Properties
    
    /// Active user profile identifier
    var currentProfileID: String? {
        get {
            return defaults.string(forKey: Key.currentProfileID.rawValue)
        }
        set {
            if newValue == nil {
                defaults.removeObject(forKey: Key.currentProfileID.rawValue)
            } else {
                defaults.set(newValue, forKey: Key.currentProfileID.rawValue)
            }
            defaults.synchronize()
        }
    }
    
    /// String array of a teacher's favorite classes
    var favorites: [String] {
        get {
            return defaults.stringArray(forKey: Key.favorites.rawValue) ?? []
        }
        set {
            defaults.set(newValue, forKey: Key.favorites.rawValue)
            defaults.synchronize()
        }
    }
}


