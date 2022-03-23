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
    }
    
    init() {
       FirebaseApp.configure()
     }
    
    var body: some Scene {
        WindowGroup {
            TabViewView()
        }
    }
}
