//
//  TabViewView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI

struct TabViewView: View {
    @State private var userRole = UserManager.shared.user?.role
    @StateObject var childrenManager = ChildrenManager()
    @StateObject var registrationManager = RegistrationManager()
    
    var body: some View {
        TabView {
            
            switch userRole {
            case .teacher:
                TeacherHomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Indberettelser")
                    }
                AbsenceClassListView()
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("Fravær")
                    }.environmentObject(registrationManager)
                ClassListView()
                    .tabItem {
                        Image(systemName: "chart.pie")
                        Text("Statistik")
                    }.environmentObject(registrationManager)
            case .parent:
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
        .accentColor(Resources.Color.Colors.frolyRed)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewView()
    }
}
