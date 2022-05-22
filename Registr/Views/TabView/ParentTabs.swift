//
//  ParentTabs.swift
//  Registr
//
//  Created by Simon Andersen on 15/04/2022.
//

import SwiftUI

struct ParentTabs: View {
    @StateObject var childrenManager = ChildrenViewModel()
    
    var body: some View {
        ParentHomeView()
            .tabItem {
                Image(systemName: "house")
                Text("Børn")
            }.environmentObject(childrenManager)
        
        ParentAbsenceRegistrationView(report: nil, absence: nil, child: nil, shouldUpdate: false, isAbsenceChange: false)
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Indberet")
            }
            .environmentObject(childrenManager)
        
        ProfileView(isTeacher: false)
            .tabItem {
                Image(systemName: "person")
                Text("Profil")
            }
    }
}

struct ParentTabs_Previews: PreviewProvider {
    static var previews: some View {
        ParentTabs()
    }
}
