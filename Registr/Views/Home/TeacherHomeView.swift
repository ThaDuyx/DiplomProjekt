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
                                AbsencesRow(report: report)
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

struct AbsencesRow: View {
    let report: Report
    
    var body: some View {
        HStack {
            HStack(spacing: 20) {
                Button { } label: {
                    Text(stringSeparator(reason: report.reason).uppercased())
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.white)
                        .background(Color.frolyRed)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                
                VStack {
                    Text(report.studentName)
                        .bodyTextStyle(color: Color.white, font: .poppinsBold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(report.description ?? "")
                        .smallBodyTextStyle(color: .white, font: .poppinsRegular)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                }
            }
            
            NavigationLink(destination: StudentReportView(report: report)) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color.white)
                .padding(.trailing, 10)
        }
    }
}

struct TeacherHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherHomeView()
    }
}
