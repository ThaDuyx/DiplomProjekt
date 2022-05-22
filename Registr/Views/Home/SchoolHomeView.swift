//
//  TeacherHomeView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/04/2022.
//

import SwiftUI

struct SchoolHomeView: View {
    
    @StateObject var reportViewModel = ReportViewModel()
    @StateObject var errorHandling = ErrorHandling()
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    @EnvironmentObject var notificationVM: NotificationViewModel
    @EnvironmentObject var classViewModel: ClassViewModel
    
    /// - Will be removed later in our process. This is commented because it's easier to access the feeder this way.
//    @StateObject var feeder = FeedDatabaseManager()
    /// -----------------------------------
    
    var body: some View {
        NavigationView {
            ZStack {
                if favoriteViewModel.favorites.isEmpty {
                    VStack(spacing: 50) {
                        Text("shs_no_favorites_1".localize)
                            .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                            .multilineTextAlignment(.leading)
                            .frame(width: 320)
                        Text("shs_no_favorites_2".localize)
                            .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                            .multilineTextAlignment(.leading)
                            .frame(width: 320)
                    }
                } else {
                    List(favoriteViewModel.favorites, id: \.self) { favorite in
                        if let favoriteIndex = classViewModel.classes.firstIndex(where: { $0.classID == favorite }) {
                            Section(
                                header: Text(classViewModel.classes[favoriteIndex].name)
                                    .headerTextStyle(color: Color.fiftyfifty, font: .poppinsMedium)
                            ) {
                                ForEach(reportViewModel.reports, id: \.self) { report in
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
                    .onChange(of: favoriteViewModel.newFavorite) { newValue in
                        reportViewModel.addFavorite(newFavorite: newValue)
                    }
                    .onChange(of: favoriteViewModel.deselectedFavorite) { deselectedValue in
                        reportViewModel.removeFavorite(favorite: deselectedValue)
                    }
                    /// - Will be removed later in our process. This is uncommented because it's easier to access the feeder this way.
//                                    Button("Feed") {
//                                        feeder.createRegistrationDates()
//                                    }
                    /// -----------------------------------
                    ///
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
                        reportViewModel.attachReportListeners()
                    } else {
                        reportViewModel.addFavorite(newFavorite: favoriteViewModel.newFavorite)
                    }
                }
            })
            .navigationTitle("reports_navigationtitle".localize)
            .navigationBarTitleDisplayMode(.inline)
        }.environmentObject(reportViewModel)
    }
}

struct TeacherHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolHomeView()
    }
}
