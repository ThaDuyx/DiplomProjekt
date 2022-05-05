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
    
    var body: some View {
        NavigationView {
            ZStack {
                List(favoriteManager.favorites, id: \.self) { favorite in
                    Section(
                        header: Text(favorite)
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
                .accentColor(Color.fiftyfifty)
                .onChange(of: favoriteManager.newFavorite) { newValue in
                    reportManager.addFavorite(newFavorite: newValue)
                }
                .onChange(of: favoriteManager.deselectedFavorite) { deselectedValue in
                    reportManager.removeFavorite(favorite: deselectedValue)
                }
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
