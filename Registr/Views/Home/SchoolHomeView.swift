//
//  TeacherHomeView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/04/2022.
//

import SwiftUI

struct SchoolHomeView: View {
    
    @StateObject var reportManager = ReportManager()
    @StateObject var errorHandling = ErrorHandling()
    @EnvironmentObject var favoriteManager: FavoriteManager
    @EnvironmentObject var notificationVM: NotificationViewModel
    @EnvironmentObject var classManager: ClassManager
    
    /// - Will be removed later in our process. This is commented because it's easier to access the feeder this way.
//    @StateObject var feeder = FeedDatabaseManager()
    /// -----------------------------------
    
    var body: some View {
        NavigationView {
            ZStack {
                List(favoriteManager.favorites, id: \.self) { favorite in
                    if let favoriteIndex = classManager.classes.firstIndex(where: { $0.classID == favorite }) {
                        Section(
                            header: Text(classManager.classes[favoriteIndex].name)
                                .headerTextStyle(color: Color.fiftyfifty, font: .poppinsMedium)
                        ) {
                            ForEach(reportManager.reports, id: \.self) { report in
                                if DefaultsManager.shared.userRole == .teacher && report.classID == favorite && report.registrationType != .legal {
                                    TeacherAbsencesSection(report: report)
                                } else if DefaultsManager.shared.userRole == .headmaster && report.classID == favorite && report.registrationType == .legal {
                                    TeacherAbsencesSection(report: report)
                                }
                            }
                            .onAppear() {
                                if !notificationVM.teacherSubscribeToNotification {
                                    notificationVM.teacherSubscribeToNotification = true
                                }
                            }
                            .listRowBackground(Color.frolyRed)
                            .listRowSeparatorTint(Color.white)
                        }
                        
                    }
                }
                .accentColor(Color.fiftyfifty)
                .onChange(of: favoriteManager.newFavorite) { newValue in
                    reportManager.addFavorite(newFavorite: newValue)
                }
                .onChange(of: favoriteManager.deselectedFavorite) { deselectedValue in
                    reportManager.removeFavorite(favorite: deselectedValue)
                }
                
                /// - Will be removed later in our process. This is commented because it's easier to access the feeder this way.
//                Button("Feed") {
//                    feeder.createRegistrationDates()
//                }
                /// -----------------------------------
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack {
                        NavigationLink {
                            ProfileView(isTeacher: true)
                        } label: {
                            Image(systemName: "person")
                        }
                    }
                }
            }
            .onAppear() {
                notificationVM.getNotificationSettings()
            }
            .fullScreenCover(item: $errorHandling.appError, content: { appError in
                ErrorView(title: appError.title, error: appError.description) {
                    if appError.type == .reportMangerInitError {
                        reportManager.attachReportListeners()
                    } else {
                        reportManager.addFavorite(newFavorite: favoriteManager.newFavorite)
                    }
                }
            })
            .navigationTitle("Indberettelser")
            .navigationBarTitleDisplayMode(.inline)
            .navigationAppearance(backgroundColor: .white)
        }.environmentObject(reportManager)
    }
}

struct TeacherHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolHomeView()
    }
}
