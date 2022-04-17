//

import SwiftUI

struct TeacherHomeScreenView: View {
     
    @StateObject var reportManager = ReportManager()
    @EnvironmentObject var favoriteManager: FavoriteManager
    
    init() {
        // To make the List background transparent, so the gradient background can be used.
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Resources.BackgroundGradient.backgroundGradient
                    .ignoresSafeArea()
                
                List(favoriteManager.favorites, id: \.self) { favorite in
                    Section(
                        header: Text(favorite)
                    ) {
                        ForEach(reportManager.reports, id: \.self) { report in
                            if report.className == favorite {
                                TaskRow(report: report)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                }.onChange(of: favoriteManager.favorites) { _ in
                    reportManager.fetchReports()
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
