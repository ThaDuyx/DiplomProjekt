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
        case userRole = "DefaultsManager_userRole"
        case childrenID = "DefaultsManager_childrenID"
    }
    
    // MARK: - Properties
    
    /// Active user profile identifier
    var currentProfileID: String {
        get {
            return defaults.string(forKey: Key.currentProfileID.rawValue) ?? ""
        }
        set {
            defaults.set(newValue, forKey: Key.currentProfileID.rawValue)
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
    
    var childrenID: [String] {
        get {
            return defaults.stringArray(forKey: Key.childrenID.rawValue) ?? []
        }
        set {
            defaults.set(newValue, forKey: Key.childrenID.rawValue)
            defaults.synchronize()
        }
    }
}


