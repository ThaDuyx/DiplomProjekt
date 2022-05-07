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
                
                GraphSection(statisticsManager: statisticsManager)
                
                Spacer()
                
                VStack(spacing: 20) {
                    AbsenceStatisticsCard(isWeekDayUsed: false, title: "statistics_morning".localize, statArray: statisticMorning(statistics: statisticsManager))
                    if student.classInfo.isDoubleRegistrationActivated {
                        AbsenceStatisticsCard(isWeekDayUsed: false, title: "statistics_afternoon".localize, statArray: statisticAfternoon(statistics: statisticsManager))
                    }
                    AbsenceStatisticsCard(isWeekDayUsed: true, title: "statistics_offenses".localize, statArray: statisticsWeekDay(statistics: statisticsManager))
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

struct StudentView_Previews: PreviewProvider {
    static var previews: some View {
        StudentView(studentName: "Student name", isParent: true, studentID: "Student ID", student: Student(name: "", className: "", email: "", classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: "", classID: ""), associatedSchool: "", cpr: ""))
    }
}
