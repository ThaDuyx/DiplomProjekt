//
//  TeacherHomeScreenView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI

struct TeacherHomeScreenView: View {
    
    @ObservedObject var reportManager = ReportManager()
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
                            TaskRow()
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Indberettelser")
            .navigationBarTitleDisplayMode(.inline)
        }.onAppear(){
            self.reportManager.fetchReports()
        }
    }
}

struct TaskRow: View {
    var body: some View {
        NavigationLink(destination: StudentAbsenceView()) {
            Text("Placeholder text - Student name")
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
