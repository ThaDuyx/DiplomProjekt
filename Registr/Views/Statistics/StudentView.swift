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
    
    @ObservedObject var statisticsManager = StatisticsManager()
    @State private var weekdaysArray: [String] = ["Man", "Tir", "Ons", "Tor", "Fre"]

    let studentName: String
    var isParent: Bool
    var studentID: String
    
    init(studentName: String, isParent: Bool, studentID: String) {
        self.studentName = studentName
        self.isParent = isParent
        self.studentID = studentID
    }

    var body: some View {
        VStack {
            
            if isParent {
                if let studentID = studentID {
                    
                    Spacer()
                    
                    StatisticsButtonSection(systemName: "doc.text.fill", titleText: "Indberettelser", destination: ReportListView(selectedStudent: studentID, studentName: studentName))

                    StatisticsButtonSection(systemName: "person.crop.circle.badge.questionmark", titleText: "Fravær", destination: AbsenceListView(selectedStudent: studentID, studentName: studentName))
                    
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
                VStack(alignment: .center, spacing: 15) {
                    
                    Text("Lovligt: Morgen - \(statisticsManager.statistic.legalMorning) & Eftermiddag - \(statisticsManager.statistic.legalAfternoon)")
                        .bodyTextStyle(color: Color.white, font: .poppinsRegular)
                        .padding(.top, 10)
                    
                    Text("Sygedage: Morgen - \(statisticsManager.statistic.illnessMorning) & Eftermiddag - \(statisticsManager.statistic.illnessAfternoon)")
                        .bodyTextStyle(color: Color.white, font: .poppinsRegular)

                    Text("Ulovligt: Morgen - \(statisticsManager.statistic.illegalMorning) & Eftermiddag - \(statisticsManager.statistic.illegalAfternoon)")
                        .bodyTextStyle(color: Color.white, font: .poppinsRegular)

                    Text("For sent: Morgen - \(statisticsManager.statistic.lateMorning) & Eftermiddag - \(statisticsManager.statistic.lateAfternoon)")
                        .bodyTextStyle(color: Color.white, font: .poppinsRegular)
                        .padding(.bottom, 10)
                    
                    Divider()
                        .frame(height: 1)
                        .background(.white)
                    
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

struct StudentView_Previews: PreviewProvider {
    static var previews: some View {
        StudentView(studentName: "Student name", isParent: true, studentID: "Student ID")
    }
}
