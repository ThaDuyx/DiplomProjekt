//
//  ClassView.swift
//  Registr
//
//  Created by Christoffer Detlef on 17/04/2022.
//

import SwiftUI
import SwiftUICharts

struct ClassView: View {
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    @EnvironmentObject var notificationVM: NotificationViewModel
    @ObservedObject var statisticsViewModel = StatisticsViewModel()
    @StateObject var errorHandling = ErrorHandling()
    
    @State private var followAction: Bool = false
    
    let classInfo: ClassInfo
    var studentID: String? = nil
    
    init(classInfo: ClassInfo, studentID: String? = nil) {
        self.classInfo = classInfo
        self.studentID = studentID
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) { 
            VStack(spacing: 20) {
                Spacer()
                Button {
                    followAction.toggle()
                    favoriteViewModel.favoriteAction(favorite: classInfo.classID)
                    addNotification()
                } label: {
                    
                    HStack {
                        Image(systemName: "checkmark.diamond")
                        
                        Text(favoriteViewModel.favorites.contains(classInfo.classID) ? "class_follow".localize : "class_not_following".localize)
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.FollowButtonStyle(isFollowed: favoriteViewModel.favorites.contains(classInfo.classID)))
                
                StatisticsButtonSection(systemName: "calendar", titleText: "class_history".localize, destination: CalendarView(classInfo: classInfo))
                
                StatisticsButtonSection(systemName: "person.3", titleText: "class_students".localize, destination: StudentListView(selectedClass: classInfo))
                
                Spacer()
                
                GraphSection(statisticsViewModel: statisticsViewModel)
                
                Spacer()
                
                VStack(spacing: 20) {
                    AbsenceStatisticsCard(isWeekDayUsed: false, title: "statistics_morning".localize, statArray: statisticMorning(statistics: statisticsViewModel))
                    if classInfo.isDoubleRegistrationActivated {
                        AbsenceStatisticsCard(isWeekDayUsed: false, title: "statistics_afternoon".localize, statArray: statisticAfternoon(statistics: statisticsViewModel))
                    }
                    AbsenceStatisticsCard(isWeekDayUsed: true, title: "statistics_offenses".localize, statArray: statisticsWeekDay(statistics: statisticsViewModel))
                }
                .onAppear() {
                    statisticsViewModel.fetchClassStats(className: classInfo.name)
                }
                
                Spacer()
            }
        }
        .fullScreenCover(item: $errorHandling.appError) { appError in
            ErrorView(title: appError.title,error: appError.description) {
                statisticsViewModel.fetchClassStats(className: classInfo.name)
            }
        }
        .onAppear() {
            notificationVM.getNotificationSettings()
        }
        .navigationTitle(classInfo.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addNotification() {
        notificationVM.nameOfSubscriptions = classInfo.classID
        
        if favoriteViewModel.favorites.contains(classInfo.classID) {
            notificationVM.subscribeToNotification = true
        } else {
            notificationVM.subscribeToNotification = false
        }
    }
}

struct ClassView_Previews: PreviewProvider {
    static var previews: some View {
        ClassView(classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: "", classID: ""))
    }
}
