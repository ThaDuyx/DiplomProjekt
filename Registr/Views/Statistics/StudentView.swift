//
//  StudentView.swift
//  Registr
//
//  Created by Christoffer Detlef on 17/04/2022.
//

import SwiftUI
import SwiftUICharts
import SwiftUIKit

struct StudentView: View {
    
    // This is for testing the chart
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    @StateObject var statisticsManager = StatisticsManager()
    @StateObject private var context = FullScreenCoverContext()
    
    let studentName: String
    var isParent: Bool
    var studentID: String
    let student: Student
    
    init(studentName: String, isParent: Bool, studentID: String, student: Student) {
        self.studentName = studentName
        self.isParent = isParent
        self.studentID = studentID
        self.student = student
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15) {
                
                if isParent {
                    if let studentID = studentID {
                        
                        Spacer()
                        
                        StatisticsButtonSection(systemName: "doc.text.fill", titleText: "statistics_reports".localize, destination: ReportListView(selectedStudent: studentID, studentName: studentName, student: student))
                        
                        StatisticsButtonSection(systemName: "person.crop.circle.badge.questionmark", titleText: "statistics_absence".localize, destination: AbsenceListView(selectedStudent: studentID, studentName: studentName, student: student))
                    }
                }
                
                Spacer()
                
                VStack {
                    PieChart()
                        .data(demoData)
                        .chartStyle(ChartStyle(
                            backgroundColor: .white,
                            foregroundColor: ColorGradient(.fiftyfifty, .fiftyfifty))
                        )
                }
                .frame(width: 150, height: 150)
                
                Spacer()
                
                VStack(spacing: 20) {
                    AbsenceStatisticsCard(isWeekDayUsed: false, title: "statistics_morning".localize, statArray: statisticMorning())
                    if student.classInfo.isDoubleRegistrationActivated {
                        AbsenceStatisticsCard(isWeekDayUsed: false, title: "statistics_afternoon".localize, statArray: statisticAfternoon())
                    }
                    AbsenceStatisticsCard(isWeekDayUsed: true, title: "statistics_offenses".localize, statArray: statisticsWeekDay())
                }
                .onAppear() {
                    statisticsManager.fetchStudentStats(studentID: studentID)
                }
                .fullScreenCover(item: $statisticsManager.appError) { appError in
                    ErrorView(title: appError.title, error: appError.description) {
                        statisticsManager.fetchStudentStats(studentID: studentID)
                    }
                }
            }
            .navigationTitle(studentName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension StudentView {
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

struct StudentView_Previews: PreviewProvider {
    static var previews: some View {
        StudentView(studentName: "Student name", isParent: true, studentID: "Student ID", student: Student(name: "", className: "", email: "", classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: ""), associatedSchool: ""))
    }
}
