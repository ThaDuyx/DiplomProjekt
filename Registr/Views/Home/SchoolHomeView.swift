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
                if favoriteViewModel.favorites.isEmpty {
                    VStack(spacing: 50) {
                        Text("Du har ikke valgt at følge nogle klasser. For at få vist beskder når en forældre fra en bestemt klasse, har oprettet fravær fra sit barn, så skal du følge denne klasse.")
                            .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                            .multilineTextAlignment(.leading)
                            .frame(width: 320)
                        Text("For at følge en klasse, så gå ind på Statistik -> vælg en klasse -> Tryk på Følger ikke. Du vil nu følge denne klasse.")
                            .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                            .multilineTextAlignment(.leading)
                            .frame(width: 320)
                    }
                } else {
                    List(classViewModel.classes, id: \.self) { classInfo in
                        if favoriteViewModel.favorites.contains(classInfo.classID) {
                            Section(
                                header: Text(classInfo.name)
                                    .headerTextStyle(color: Color.fiftyfifty, font: .poppinsMedium)
                            ) {
                                ForEach(reportViewModel.reports, id: \.self) { report in
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
                    .onChange(of: favoriteViewModel.newFavorite) { newValue in
                        reportViewModel.addFavorite(newFavorite: newValue)
                    }
                    .onChange(of: favoriteViewModel.deselectedFavorite) { deselectedValue in
                        reportViewModel.removeFavorite(favorite: deselectedValue)
                    }
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
            .navigationTitle("Indberettelser")
            .navigationBarTitleDisplayMode(.inline)
        }.environmentObject(reportViewModel)
    }
}

struct TeacherHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolHomeView()
    }
}
