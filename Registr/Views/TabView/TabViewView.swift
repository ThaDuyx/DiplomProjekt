//
//  TabViewView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI

struct TabViewView: View {
    @State private var role: String = ""
    
    var body: some View {
        TabView {
            if role == "parent" {
                ParentHomeScreenView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Start")
                    }
            } else {
            TeacherHomeScreenView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Start")
                }
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
        }
        .accentColor(Resources.Color.Colors.darkBlue)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewView()
    }
}
