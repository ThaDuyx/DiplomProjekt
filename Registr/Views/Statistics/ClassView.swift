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
                
                if statisticsWeekDay().isEmpty || statisticsWeekDay().allSatisfy { $0 == 0 } {
                    Text("Der kan ikke blive vist nogen graf på fraværet for hver dag i ugen, da der intet er.")
                        .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                        .multilineTextAlignment(.leading)
                        .frame(width: 320)
                } else {
                    VStack {
                        PieChartView(data: statisticsWeekDay().map { Double($0) }, title: "Fraværs værdi", legend: "Fravær fra ugen", style: ChartStyle(backgroundColor: .white, accentColor: Color.fiftyfifty, gradientColor: GradientColor(start: Color.fiftyfifty, end: Color.fiftyfifty), textColor: Color.fiftyfifty, legendTextColor: .fiftyfifty, dropShadowColor: .clear))
                    }
                }
                
                Spacer()
                
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
