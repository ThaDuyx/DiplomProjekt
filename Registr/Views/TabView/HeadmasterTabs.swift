//
//  HeadmasterTabs.swift
//  Registr
//
//  Created by Simon Andersen on 03/05/2022.
//

import Foundation
import SwiftUI

struct HeadmasterTabs: View {
    @StateObject var registrationViewModel = RegistrationViewModel()
    @StateObject var favoriteViewModel = FavoriteViewModel()
    @StateObject var classViewModel = ClassViewModel()
    
    var body: some View {
        SchoolHomeView()
            .tabItem {
                Image(systemName: "house")
                Text("Indberettelser")
            }
            .environmentObject(favoriteViewModel)
            .environmentObject(classViewModel)
        
        ClassListView()
            .tabItem {
                Image(systemName: "chart.pie")
                Text("Statistik")
            }
            .environmentObject(registrationViewModel)
            .environmentObject(favoriteViewModel)
            .environmentObject(classViewModel)
    }
}

struct HeadmasterTabs_Previews: PreviewProvider {
    static var previews: some View {
        HeadmasterTabs()
    }
}
