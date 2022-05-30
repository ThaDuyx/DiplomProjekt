//
//  ParentTabs.swift
//  Registr
//
//  Created by Simon Andersen on 15/04/2022.
//

import SwiftUI

struct ParentTabs: View {
    @StateObject var childrenViewModel = ChildrenViewModel()
    
    var body: some View {
        ParentHomeView()
            .tabItem {
                Image(systemName: "house")
                Text("ph_navigationtitle".localize)
            }.environmentObject(childrenViewModel)
        
        ParentAbsenceRegistrationView(report: nil, absence: nil, child: nil, shouldUpdate: false, isAbsenceChange: false)
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("pt_report".localize)
            }
            .environmentObject(childrenViewModel)
        
        ProfileView(isTeacher: false)
            .tabItem {
                Image(systemName: "person")
                Text("profile_navigationtitle".localize)
            }
    }
}

struct ParentTabs_Previews: PreviewProvider {
    static var previews: some View {
        ParentTabs()
    }
}
