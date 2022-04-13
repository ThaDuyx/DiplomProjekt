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
        }
    }
}

struct TeacherHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherHomeView()
    }
}
