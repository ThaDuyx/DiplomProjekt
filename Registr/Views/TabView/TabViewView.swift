//
//  TabViewView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI

struct TabViewView: View {
    @State private var userRole = UserManager.shared.user?.role
    
    var body: some View {
        TabView {
            
            switch userRole {
            case .teacher:
                TeacherTabs()
            case .parent:
                ParentTabs()
            case .headmaster:
                // TODO: Make headmaster view
                ParentHomeScreenView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Start")
                    }
            case .none:
                // Missing error handling here.
                let _ = print("Something went wrong")
            }
        }
        .accentColor(Resources.Color.Colors.darkBlue)
    }
}

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

struct ParentTabs: View {
    @StateObject var childrenManager = ChildrenManager()
    
    var body: some View {
        ParentHomeScreenView()
            .tabItem {
                Image(systemName: "house")
                Text("Børn")
            }.environmentObject(childrenManager)
        
        ParentAbsenceRegistrationView()
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Indberet")
            }.environmentObject(childrenManager)
        
        ProfileView()
            .tabItem {
                Image(systemName: "person")
                Text("Profil")
            }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewView()
    }
}
