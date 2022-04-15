//
//  TeacherTabs.swift
//  Registr
//
//  Created by Simon Andersen on 15/04/2022.
//

import SwiftUI

struct TeacherTabs: View {
    @StateObject var registrationManager = RegistrationManager()
    @StateObject var favoriteManager = FavoriteManager()
    
    var body: some View {
        TeacherHomeScreenView()
            .tabItem {
                Image(systemName: "house")
                Text("Start")
            }
            .environmentObject(favoriteManager)
        
        RegisterView()
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Registrer")
            }
            .environmentObject(registrationManager)
            .environmentObject(favoriteManager)
        
        ClassListView()
            .tabItem {
                Image(systemName: "chart.pie")
                Text("Statistik")
            }
            .environmentObject(registrationManager)
            .environmentObject(favoriteManager)
        
        ProfileView()
            .tabItem {
                Image(systemName: "person")
                Text("Profil")
            }
    }
}

struct TeacherTabs_Previews: PreviewProvider {
    static var previews: some View {
        TeacherTabs()
    }
}
