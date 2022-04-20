//
//  TabViewView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI

struct TabViews: View {
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
                ParentHomeView()
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
        TabViews()
    }
}
