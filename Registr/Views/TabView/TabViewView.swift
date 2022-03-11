//
//  TabViewView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI

struct TabViewView: View {
    var body: some View {
        
        TabView {
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
        }
        .accentColor(Resources.Color.Colors.darkBlue)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewView()
    }
}
