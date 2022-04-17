//
//  TeacherHomeView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/04/2022.
//

import SwiftUI

struct TeacherHomeView: View {
    
    @StateObject var reportManager = ReportManager()
    @State var favorites = DefaultsManager.shared.favorites
    
    var body: some View {
        NavigationView {
            ZStack {
                List(favorites, id: \.self) { favorite in
                    Section(
                        header: Text(favorite)
                            .headerTextStyle()
                    ) {
                        ForEach(reportManager.reports, id: \.self) { report in
                            if report.className == favorite {
                                AbsencesRow(report: report).environmentObject(reportManager)
                            }
                        }
                    }
                    .listRowBackground(Resources.Color.Colors.frolyRed)
                    .listRowSeparatorTint(Resources.Color.Colors.white)
                }
                .accentColor(Resources.Color.Colors.fiftyfifty)
            }
            .navigationTitle("Indberettelser")
            .navigationBarTitleDisplayMode(.inline)
        }
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
                        .foregroundColor(Resources.Color.Colors.white)
                        .background(Resources.Color.Colors.frolyRed)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Resources.Color.Colors.white, lineWidth: 2)
                        )
                }
                VStack {
                    Text(report.studentName)
                        .boldBodyTextStyle()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(report.description ?? "")
                        .smallBodyTextStyle()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                }
            }
            NavigationLink(destination: StudentReportView(report: report)) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            Image(systemName: "chevron.right")
                .foregroundColor(Resources.Color.Colors.white)
                .padding(.trailing, 10)
        }
    }
}

struct TeacherHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherHomeView()
    }
}
