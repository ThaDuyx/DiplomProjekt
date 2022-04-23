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
    
    @UIApplicationDelegateAdaptor(RegistrAppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var notificationVM = NotificationViewModel()

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
            ProfileView().environmentObject(notificationVM)
        }
        .onChange(of: scenePhase) { phase in
            print("The newValue iss: \(phase)")
            if phase == .active {
                notificationVM.isViewActive = true
            } else {
                notificationVM.isViewActive = false
            }
        }
    }
}
