//
//  AbsenceClassListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 15/04/2022.
//

import SwiftUI

struct AbsenceClassListView: View {
    @EnvironmentObject var registrationManager: RegistrationManager
    @EnvironmentObject var favoriteManager: FavoriteManager
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    // Favorite classes
                    Section(
                        header:
                            HStack {
                                Image(systemName: "star")
                                
                                Text("register_section_header_favoritter")
                                    .boldDarkBodyTextStyle()
                            }
                    ) {
                        ForEach(registrationManager.classes, id: \.self) { className in
                            if favoriteManager.favorites.contains(className) {
                                ClassRow(className: className, isFavorite: true)
                            }
                        }
                    }
                    .listRowBackground(Resources.Color.Colors.frolyRed)
                    .listRowSeparatorTint(Resources.Color.Colors.white)
                    
                    // Non-favorite classes
                    Section(
                        header:
                            HStack {
                                Image(systemName: "person.3")
                                
                                Text("register_section_header_classes")
                                    .boldDarkBodyTextStyle()
                            }
                    ) {
                        ForEach(registrationManager.classes, id: \.self) { className in
                            if !favoriteManager.favorites.contains(className) {
                                ClassRow(className: className, isFavorite: false)
                            }
                        }
                    }
                    .listRowBackground(Resources.Color.Colors.frolyRed)
                    .listRowSeparatorTint(Resources.Color.Colors.white)
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Fravær")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
struct ClassRow: View {
    var className: String
    var isFavorite: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(Resources.Color.Colors.white)
                
                Text(className)
                    .smallSubTitleTextStyle()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            // Setting frame and opacity to 0, to remove chevron
            NavigationLink(destination: AbsenceRegistrationView(selectedClass: className, selectedDate: Date().currentDateFormatted, isFromHistory: false)) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)
            
            Image(systemName: "chevron.right")
                .foregroundColor(Resources.Color.Colors.white)
                .padding(.trailing, 10)
        }
        .frame(height: 55)
    }
}

struct AbsenceClassListView_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceClassListView()
    }
}
