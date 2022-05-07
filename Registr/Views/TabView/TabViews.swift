//
//  TabViewView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI

struct TabViews: View {
    @State private var userRole = DefaultsManager.shared.userRole
    
    init() {
        NavigationAndTabbarAppearance.configureAppearance(clear: false)
    }
    
    var body: some View {
        TabView {
            switch userRole {
            case .teacher:
                TeacherTabs()
                
            case .parent:
                ParentTabs()
                
            case .headmaster:
                HeadmasterTabs()
                
                // This case will only be called if there is an active auth token and there has been an update or reinstallation of the app.
                // Could also be a memory issue. Regardless of the error we would just like the user to login again.
            case .none:
                LoginOptions()
            }
        }
        .accentColor(.frolyRed)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViews()
    }
}
