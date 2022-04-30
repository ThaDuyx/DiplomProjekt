//
//  TeacherHomeView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/04/2022.
//

import SwiftUI

struct TeacherHomeView: View {
    
    @StateObject var reportManager = ReportManager()
    @EnvironmentObject var favoriteManager: FavoriteManager
    
    var body: some View {
        NavigationView {
            ZStack {
                List(favoriteManager.favorites, id: \.self) { favorite in
                    Section(
                        header: Text(favorite)
                            .headerTextStyle(color: Color.fiftyfifty, font: .poppinsMedium)
                    ) {
                        ForEach(reportManager.reports, id: \.self) { report in
                            if report.className == favorite {
                                TeacherAbsencesSection(report: report)
                            }
                        }
                        .listRowBackground(Color.frolyRed)
                        .listRowSeparatorTint(Color.white)
                    }
                }
                .accentColor(Color.fiftyfifty)
                .onChange(of: favoriteManager.newFavorite) { newValue in
                    reportManager.addFavorite(newFavorite: newValue)
                }
                .onChange(of: favoriteManager.deselectedFavorite) { deselectedValue in
                    reportManager.removeFavorite(favorite: deselectedValue)
                }
            }
            .navigationTitle("Indberettelser")
            .navigationBarTitleDisplayMode(.inline)
            .navigationAppearance(backgroundColor: .white)
        }.environmentObject(reportManager)
    }
}

struct TeacherHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherHomeView()
    }
}
