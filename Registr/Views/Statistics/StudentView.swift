//
//  StudentView.swift
//  Registr
//
//  Created by Christoffer Detlef on 17/04/2022.
//

import SwiftUI
import SwiftUICharts

struct StudentView: View {
    
    @StateObject var statisticsManager = StatisticsManager()
    @StateObject var errorHandling = ErrorHandling()
    
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
                    if student.classInfo.isDoubleRegistrationActivated {
                        AbsenceStatisticsCard(isWeekDayUsed: false, title: "statistics_afternoon".localize, statArray: statisticAfternoon())
                    }
                    AbsenceStatisticsCard(isWeekDayUsed: true, title: "statistics_offenses".localize, statArray: statisticsWeekDay())
                }
                .onAppear() {
                    statisticsManager.fetchStudentStats(studentID: studentID)
                }
                .fullScreenCover(item: $errorHandling.appError) { appError in
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
