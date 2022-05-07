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
        case isAuthenticated = "DefaultsManager_isAuthenticated"
        case associatedSchool = "DefaultsManager_associatedSchool"
        case userName = "DefaultsManager_userName"
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
    
    var userRole: Role {
        get {
            // Force unwrapping these because if we don't have a role it means the user haven't logged in.
            let roleRawValue = defaults.string(forKey: Key.userRole.rawValue) ?? "none"
            let role = Role(rawValue: roleRawValue)!
            
            return role
        }
        set {
            defaults.set(newValue.rawValue, forKey: Key.userRole.rawValue)
            defaults.synchronize()
        }
    }
    
    var associatedSchool: String {
        get {
            return defaults.string(forKey: Key.associatedSchool.rawValue) ?? "" 
        }
        set {
            defaults.set(newValue, forKey: Key.associatedSchool.rawValue)
            defaults.synchronize()
        }
    }
    
    var userName: String {
        get {
            return defaults.string(forKey: Key.associatedSchool.rawValue) ?? ""
        } set {
            defaults.set(newValue, forKey: Key.userName.rawValue)
            defaults.synchronize()
        }
    }
    
    var isAuthenticated: Bool {
        get {
            return defaults.bool(forKey: Key.isAuthenticated.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.isAuthenticated.rawValue)
        }
    }
    
    func flushDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
        print(Array(defaults.dictionaryRepresentation().keys).count)
    }
}
