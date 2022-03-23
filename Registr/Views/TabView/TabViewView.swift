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
                TeacherHomeScreenView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Start")
                    }
                
                RegisterView()
                    .tabItem {
                        Image(systemName: "square.and.pencil")
                        Text("Registrer")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profil")
                    }
            case .parent:
                ParentHomeScreenView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Start")
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
        .accentColor(Resources.Color.Colors.darkBlue)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewView()
    }
}
