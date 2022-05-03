//
//  HeadmasterTabs.swift
//  Registr
//
//  Created by Simon Andersen on 03/05/2022.
//

import Foundation
import SwiftUI

struct HeadmasterTabs: View {
    @StateObject var registrationManager = RegistrationManager()
    
    var body: some View {
        TeacherHomeView()
            .tabItem {
                Image(systemName: "house")
                Text("Indberettelser")
            }
        
        ClassListView()
            .tabItem {
                Image(systemName: "chart.pie")
                Text("Statistik")
            }
            .environmentObject(registrationManager)
    }
}

struct HeadmasterTabs_Previews: PreviewProvider {
    static var previews: some View {
        HeadmasterTabs()
    }
}
