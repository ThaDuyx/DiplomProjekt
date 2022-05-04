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
                HeadmasterTabs()
                
            case .none:
                ErrorView(title: "alert_title".localize, error: "alert_default_description".localize)
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
