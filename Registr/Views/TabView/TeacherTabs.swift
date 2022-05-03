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
        SchoolHomeView()
            .tabItem {
                Image(systemName: "house")
                Text("Indberettelser")
            }
            .environmentObject(favoriteManager)
        
        AbsenceClassListView()
            .tabItem {
                Image(systemName: "plus.circle")
                Text("Fravær")
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
    }
}

struct TeacherTabs_Previews: PreviewProvider {
    static var previews: some View {
        TeacherTabs()
    }
}
