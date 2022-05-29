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
    
    var body: some View {
        NavigationView {
            ZStack {
                if self.favoriteViewModel.favorites.isEmpty {
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
                    List(self.classViewModel.classes, id: \.self) { classInfo in
                        if self.favoriteViewModel.favorites.contains(classInfo.classID) {
                            Section(
                                header: Text(classInfo.name)
                                    .headerTextStyle(color: Color.fiftyfifty, font: .poppinsMedium)
                            ) {
                                ForEach(self.reportViewModel.reports, id: \.self) { report in
                                    if DefaultsManager.shared.userRole == .teacher && report.classID == classInfo.classID && report.registrationType != .legal {
                                        TeacherAbsencesSection(report: report)
                                    } else if DefaultsManager.shared.userRole == .headmaster && report.classID == classInfo.classID && report.registrationType == .legal {
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
            .onChange(of: self.favoriteViewModel.newFavorite) { newValue in
                self.reportViewModel.addFavorite(newFavorite: newValue)
            }
            .onChange(of: self.favoriteViewModel.deselectedFavorite) { deselectedValue in
                self.reportViewModel.removeFavorite(favorite: deselectedValue)
            }
            .onAppear() {
                notificationVM.getNotificationSettings()
            }
            .fullScreenCover(item: $errorHandling.appError, content: { appError in
                ErrorView(title: appError.title, error: appError.description) {
                    if appError.type == .reportMangerInitError {
                        self.reportViewModel.attachReportListeners()
                    } else {
                        self.reportViewModel.addFavorite(newFavorite: self.favoriteViewModel.newFavorite)
                    }
                }
            })
            .navigationTitle("reports_navigationtitle".localize)
            .navigationBarTitleDisplayMode(.inline)
        }
        .environmentObject(reportViewModel)
    }
}

struct TeacherHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolHomeView()
    }
}
