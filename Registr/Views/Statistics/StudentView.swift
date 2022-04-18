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
                    
                    ButtonAction(systemName: "doc.text.fill", titleText: "Indberettelser", destination: EmptyView())
                    
                    ButtonAction(systemName: "person.crop.circle.badge.questionmark", titleText: "Fravær", destination: ReportListView(selectedStudent: studentID, studentName: studentName))
                    
                }
            }
            VStack {
                PieChart()
                    .data(demoData)
                    .chartStyle(ChartStyle(backgroundColor: .white,
                                           foregroundColor: ColorGradient(Resources.Color.Colors.fiftyfifty, Resources.Color.Colors.fiftyfifty)))
            }
            .frame(width: 150, height: 150)
            
            VStack(alignment: .leading, spacing: -10) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(Resources.Color.Colors.fiftyfifty)
                    Text("Statistik")
                        .boldDarkBodyTextStyle()
                        .padding(.leading, 20)
                }
                VStack(alignment: .center, spacing: 15) {
                    
                    Text("Lovligt: \(statisticsManager.statistic.legal)")
                        .lightBodyTextStyle()
                        .padding(.top, 10)
                    
                    Text("Sygedage: \(statisticsManager.statistic.illness)")
                        .lightBodyTextStyle()
                    
                    Text("Ulovligt: \(statisticsManager.statistic.illegal)")
                        .lightBodyTextStyle()
                    
                    Text("For sent: \(statisticsManager.statistic.late)")
                        .lightBodyTextStyle()
                        .padding(.bottom, 10)
                    
                    Divider()
                        .frame(height: 1)
                        .background(.white)
                    
                    VStack(spacing: 10) {
                        Text("Forseelser:")
                            .lightBodyTextStyle()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        
                        HStack {
                            ForEach(weekdaysArray, id: \.self) { index in
                                VStack {
                                    Text(index)
                                        .lightBodyTextStyle()
                                    Text("4")
                                        .lightBodyTextStyle()
                                }
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                                Spacer()
                            }
                        }
                    }
                }
                .frame(width: 290)
                .background(Resources.Color.Colors.frolyRed)
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
