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
    
    var body: some View {
        SchoolHomeView()
            .tabItem {
                Image(systemName: "house")
                Text("Indberettelser")
            }
            .environmentObject(favoriteViewModel)
        
        ClassListView()
            .tabItem {
                Image(systemName: "chart.pie")
                Text("Statistik")
            }
            .environmentObject(registrationViewModel)
            .environmentObject(favoriteViewModel)
    }
}

struct HeadmasterTabs_Previews: PreviewProvider {
    static var previews: some View {
        HeadmasterTabs()
    }
}
