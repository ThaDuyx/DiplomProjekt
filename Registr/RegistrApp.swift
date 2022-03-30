//
//  RegistrApp.swift
//  Registr
//
//  Created by Simon Andersen on 02/03/2022.
//

import SwiftUI
import FirebaseCore

@main
struct RegistrApp: App {
    
    init() {
        NavigationAndTabbarAppearance.configureAppearance()
        FirebaseApp.configure()
        
        // Hardcoded for test
        if DefaultsManager.shared.favorites.isEmpty {
            let favoriteArray = ["0.x", "1.x"]
            DefaultsManager.shared.favorites = favoriteArray
        }
    }
    
    var body: some Scene {
        WindowGroup {
            LoginOptions()
        }
    }
}
