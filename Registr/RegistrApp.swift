//
//  RegistrApp.swift
//  Registr
//
//  Created by Simon Andersen on 02/03/2022.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct RegistrApp: App {
    
    @UIApplicationDelegateAdaptor(RegistrAppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var notificationVM = NotificationViewModel()
    @State var authenticationState: Bool = false
    
    init() {
        // Hardcoded for test
        if DefaultsManager.shared.favorites.isEmpty {
            let favoriteArray = ["KkT176TAZiImYfurOJuk", "YmORb5urte0Lw3H10lmB", "Gf88KZ9GHf38Tr1XNLxk"]
            DefaultsManager.shared.favorites = favoriteArray
        }
    }
    
    var body: some Scene {
        WindowGroup {
            LoginOptions().environmentObject(notificationVM)
                .onAppear {
                    AuthenticationManager.shared.checkAuthenticationStatus { authenticated in
                        if authenticated {
                            authenticationState = true
                        } else {
                            authenticationState = false
                        }
                    }
                }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                notificationVM.isViewActive = true
            } else {
                notificationVM.isViewActive = false
            }
        }
        .onChange(of: authenticationState) { authChange in
            if authChange {
                let window = UIApplication
                    .shared
                    .connectedScenes
                    .flatMap{( $0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }
                window?.rootViewController = UIHostingController(rootView: TabViews().environmentObject(notificationVM))
            }
        }
    }
}
