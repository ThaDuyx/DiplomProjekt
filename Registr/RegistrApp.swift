//
//  RegistrApp.swift
//  Registr
//
//  Created by Simon Andersen on 02/03/2022.
//

import SwiftUI

@main
struct RegistrApp: App {
    
    init() {
        NavigationAndTabbarAppearance.configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            TabViewView()
        }
    }
}
