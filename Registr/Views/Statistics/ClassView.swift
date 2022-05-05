//
//  ClassView.swift
//  Registr
//
//  Created by Christoffer Detlef on 17/04/2022.
//

import SwiftUI
import SwiftUICharts

struct ClassView: View {
    @EnvironmentObject var favoriteManager: FavoriteManager
    @EnvironmentObject var notificationVM: NotificationViewModel
    @ObservedObject var statisticsManager = StatisticsManager()
    @StateObject var errorHandling = ErrorHandling()
    
    @State private var followAction: Bool = false
    
    let classInfo: ClassInfo
    var studentID: String? = nil
    
    // This is for testing the chart
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
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
                    favoriteManager.favoriteAction(favorite: classInfo.classID)
                    addNotification()
                } label: {
                    
                    HStack {
                        Image(systemName: "checkmark.diamond")
                        
                        Text(favoriteManager.favorites.contains(classInfo.classID) ? "Følger" : "Følger ikke")
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.FollowButtonStyle(isFollowed: favoriteManager.favorites.contains(classInfo.classID)))
                
                StatisticsButtonSection(systemName: "calendar", titleText: "Historik", destination: CalendarView(classInfo: classInfo))
                
                StatisticsButtonSection(systemName: "person.3", titleText: "Elever", destination: StudentListView(selectedClass: classInfo.name))
                
                Spacer()
                
                VStack {
                    PieChart()
                        .data(demoData)
                        .chartStyle(ChartStyle(backgroundColor: .white,
                                               foregroundColor: ColorGradient(Color.fiftyfifty, Color.fiftyfifty)))
                }
                .frame(width: 150, height: 150)
                
                VStack(spacing: 20) {
                    AbsenceStatisticsCard(isWeekDayUsed: false, title: "statistics_morning".localize, statArray: statisticMorning())
                    if classInfo.isDoubleRegistrationActivated {
                        AbsenceStatisticsCard(isWeekDayUsed: false, title: "statistics_afternoon".localize, statArray: statisticAfternoon())
                    }
                    AbsenceStatisticsCard(isWeekDayUsed: true, title: "statistics_offenses".localize, statArray: statisticsWeekDay())
                }
                .onAppear() {
                    statisticsManager.fetchClassStats(className: classInfo.name)
                }
                
                Spacer()
            }
        }
        .fullScreenCover(item: $errorHandling.appError) { appError in
            ErrorView(title: appError.title,error: appError.description) {
                statisticsManager.fetchClassStats(className: classInfo.name)
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
        
        if favoriteManager.favorites.contains(classInfo.classID) {
            notificationVM.subscribeToNotification = true
        } else {
            notificationVM.subscribeToNotification = false
        }
    }
}

extension ClassView {
    private func statisticMorning() -> [Int] {
        var morningArray: [Int] = []
        morningArray.append(statisticsManager.statistic.lateMorning)
        morningArray.append(statisticsManager.statistic.illnessMorning)
        morningArray.append(statisticsManager.statistic.legalMorning)
        morningArray.append(statisticsManager.statistic.illegalMorning)
        return morningArray
    }
    
    private func statisticAfternoon() -> [Int] {
        var afternoonArray: [Int] = []
        afternoonArray.append(statisticsManager.statistic.lateAfternoon)
        afternoonArray.append(statisticsManager.statistic.illnessAfternoon)
        afternoonArray.append(statisticsManager.statistic.legalAfternoon)
        afternoonArray.append(statisticsManager.statistic.illegalAfternoon)
        return afternoonArray
    }
    
    private func statisticsWeekDay() -> [Int] {
        var weekdayArray: [Int] = []
        weekdayArray.append(statisticsManager.statistic.mon)
        weekdayArray.append(statisticsManager.statistic.tue)
        weekdayArray.append(statisticsManager.statistic.wed)
        weekdayArray.append(statisticsManager.statistic.thu)
        weekdayArray.append(statisticsManager.statistic.fri)
        return weekdayArray
    }
}

struct ClassView_Previews: PreviewProvider {
    static var previews: some View {
        ClassView(classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: "", classID: ""))
    }
}
