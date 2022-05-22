//
//  TeacherTabs.swift
//  Registr
//
//  Created by Simon Andersen on 15/04/2022.
//

import SwiftUI

struct TeacherTabs: View {
    @StateObject var registrationViewModel = RegistrationViewModel()
    @StateObject var favoriteViewModel = FavoriteViewModel()
    @StateObject var classesViewModel = ClassViewModel()

    var body: some View {
        SchoolHomeView()
            .tabItem {
                Image(systemName: "house")
                Text("reports_navigationtitle".localize)
            }
            .environmentObject(favoriteViewModel)
            .environmentObject(classesViewModel)
        
        AbsenceClassListView()
            .tabItem {
                Image(systemName: "plus.circle")
                Text("acl_navigationtitle".localize)
            }
            .environmentObject(registrationViewModel)
            .environmentObject(favoriteViewModel)
            .environmentObject(classesViewModel)
        
        ClassListView()
            .tabItem {
                Image(systemName: "chart.pie")
                Text("cl_navigationtitle".localize)
            }
            .environmentObject(registrationViewModel)
            .environmentObject(favoriteViewModel)
            .environmentObject(classesViewModel)
    }
}

struct TeacherTabs_Previews: PreviewProvider {
    static var previews: some View {
        TeacherTabs()
    }
}
