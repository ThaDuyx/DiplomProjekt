//
//  ClassListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 24/03/2022.
//

import SwiftUI

struct ClassListView: View {
    @EnvironmentObject var registrationManager: RegistrationManager
    @StateObject var errorHandling = ErrorHandling()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(registrationManager.classes, id: \.self) { classInfo in
                        ClassSection(classInfo: classInfo)
                    }
                    .listRowBackground(Color.frolyRed)
                    .listRowSeparatorTint(Color.white)
                }
            }
            .fullScreenCover(item: $errorHandling.appError, content: { appError in
                ErrorView(title: appError.title, error: appError.description) {
                    registrationManager.fetchClasses()
                }
            })
            .navigationTitle("Statistik")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ClassListView_Previews: PreviewProvider {
    static var previews: some View {
        ClassListView()
    }
}
