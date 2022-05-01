//
//  StudentView.swift
//  Registr
//
//  Created by Christoffer Detlef on 17/04/2022.
//

import SwiftUI
import SwiftUICharts

struct StudentView: View {
    
    // This is for testing the chart
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    @StateObject var statisticsManager = StatisticsManager()
    @State private var weekdaysArray: [String] = ["Man", "Tir", "Ons", "Tor", "Fre"]
    
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
        VStack {
            
            if isParent {
                if let studentID = studentID {
                    
                    Spacer()
                    
                    StatisticsButtonSection(systemName: "doc.text.fill", titleText: "Indberettelser", destination: ReportListView(selectedStudent: studentID, studentName: studentName, student: student))

                    StatisticsButtonSection(systemName: "person.crop.circle.badge.questionmark", titleText: "Fravær", destination: AbsenceListView(selectedStudent: studentID, studentName: studentName, student: student))
                    
                }
            }

                VStack {
                    PieChart()
                        .data(demoData)
                        .chartStyle(ChartStyle(backgroundColor: .white,
                                               foregroundColor: ColorGradient(Color.fiftyfifty, Color.fiftyfifty)))
                }
                .frame(width: 150, height: 150)
                
                VStack(alignment: .leading, spacing: -10) {
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(Color.fiftyfifty)
                        Text("Statistik")
                            .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                            .padding(.leading, 20)
                    }
                    VStack(alignment: .center, spacing: 10) {
                        
                        StatisticCollection(isDoubleRegistrationActivated: student.classInfo.isDoubleRegistrationActivated, statistics: statisticsManager.statistic)
                        
                        VStack(spacing: 10) {
                            Text("Forseelser:")
                                .bodyTextStyle(color: Color.white, font: .poppinsRegular)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                            
                            HStack {
                                ForEach(weekdaysArray, id: \.self) { index in
                                    VStack {
                                        Text(index)
                                            .bodyTextStyle(color: Color.white, font: .poppinsRegular)
                                        Text("4")
                                            .bodyTextStyle(color: Color.white, font: .poppinsRegular)
                                    }
                                    .padding(.leading, 20)
                                    .padding(.bottom, 10)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .frame(width: 290)
                    .background(Color.frolyRed)
                    .cornerRadius(20)
                    .padding()
                }
                .onAppear() {
                    statisticsManager.fetchStudentStats(studentID: studentID)
                }
                
                Spacer()
            }
            .navigationTitle(studentName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct StatisticCollection: View {
    let isDoubleRegistrationActivated: Bool
    var statistics: Statistics
    
    var body: some View {
        
        StatisticsInfo(heading: "For sent:", morningStatistic: statistics.lateMorning, afterNoonStatistic: statistics.lateAfternoon, isDoubleRegistrationActivated: isDoubleRegistrationActivated)
        
        StatisticsInfo(heading: "Syg:", morningStatistic: statistics.illnessAfternoon, afterNoonStatistic: statistics.illnessAfternoon, isDoubleRegistrationActivated: isDoubleRegistrationActivated)
        
        StatisticsInfo(heading: "Ulovligt:", morningStatistic: statistics.illegalMorning, afterNoonStatistic: statistics.illegalAfternoon, isDoubleRegistrationActivated: isDoubleRegistrationActivated)
        
        StatisticsInfo(heading: "Lovligt:", morningStatistic: statistics.legalMorning, afterNoonStatistic: statistics.legalAfternoon, isDoubleRegistrationActivated: isDoubleRegistrationActivated)
        
    }
}

struct StatisticsInfo: View {
    let heading: String
    let morningStatistic: Int
    let afterNoonStatistic: Int
    let isDoubleRegistrationActivated: Bool
    
    var body: some View {
        Text(heading)
            .bodyTextStyle(color: Color.white, font: .poppinsRegular)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
        
        VStack {
            Text("Morgen - \(morningStatistic)")
                .bodyTextStyle(color: Color.white, font: .poppinsRegular)
            
            if isDoubleRegistrationActivated {
                Text("Eftermiddag - \(afterNoonStatistic)")
                    .bodyTextStyle(color: Color.white, font: .poppinsRegular)
            }
        }
        
        Divider()
            .frame(height: 1)
            .background(.white)
    }
}

struct StudentView_Previews: PreviewProvider {
    static var previews: some View {
        StudentView(studentName: "Student name", isParent: true, studentID: "Student ID", student: Student(name: "", className: "", email: "", classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: ""), associatedSchool: ""))
    }
}
