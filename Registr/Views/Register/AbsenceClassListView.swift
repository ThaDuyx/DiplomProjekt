//
//  AbsenceClassListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 15/04/2022.
//

import SwiftUI

struct AbsenceClassListView: View {
    @EnvironmentObject var classViewModel: ClassViewModel
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    @StateObject var errorHandling = ErrorHandling()
    
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
                                    .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                            }
                    ) {
                        ForEach(classViewModel.classes, id: \.self, content: { classInfo in
                            if favoriteViewModel.favorites.contains(classInfo.classID) {
                                RegistrationClassSection(classInfo: classInfo, isFavorite: true)
                            }
                        })
                    }
                    .listRowBackground(Color.frolyRed)
                    .listRowSeparatorTint(Color.white)
                    
                    // Non-favorite classes
                    Section(
                        header:
                            HStack {
                                Image(systemName: "person.3")
                                
                                Text("register_section_header_classes")
                                    .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                            }
                    ) {
                        ForEach(classViewModel.classes, id: \.self, content: { classInfo in
                            if !favoriteViewModel.favorites.contains(classInfo.classID) {
                                RegistrationClassSection(classInfo: classInfo, isFavorite: false)
                            }
                        })
                    }
                    .listRowBackground(Color.frolyRed)
                    .listRowSeparatorTint(Color.white)
                }
                .listStyle(.insetGrouped)
            }
            .fullScreenCover(item: $errorHandling.appError, content: { appError in
                ErrorView(title: appError.title, error: appError.description) {
                    classViewModel.fetchClasses()
                }
            })
            .navigationTitle("Fravær")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AbsenceClassListView_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceClassListView()
    }
}
