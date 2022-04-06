//
//  TeacherHomeScreenView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI

struct TeacherHomeScreenView: View {
     
    @StateObject var reportManager = ReportManager()
    @State var favorites = DefaultsManager.shared.favorites
    
    init() {
        // To make the List background transparent, so the gradient background can be used.
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Resources.BackgroundGradient.backgroundGradient
                    .ignoresSafeArea()
                
                List(favorites, id: \.self) { favorite in
                    Section(
                        header: Text(favorite)
                            .boldSubTitleTextStyle()
                    ) {
                        ForEach(reportManager.reports, id: \.self) { report in
                            if report.className == favorite {
                                TaskRow(report: report).environmentObject(reportManager)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Indberettelser")
            .navigationBarTitleDisplayMode(.inline)
        }.environmentObject(reportManager)
    }
}

struct TaskRow: View {
    let report: Report
    
    var body: some View {
        NavigationLink(destination: StudentAbsenceView(report: report)) {
            Text(report.studentName)
                .subTitleTextStyle()
                .lineLimit(1)
        }
    }
}

struct TeacherHomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherHomeScreenView()
    }
}
