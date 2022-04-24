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
    @ObservedObject var statisticsManager = StatisticsManager()
    
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
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                Button {
                    followAction.toggle()
                    favoriteManager.favoriteAction(favorite: classInfo.name)
                } label: {
                    
                    HStack {
                        Image(systemName: "checkmark.diamond")
                        
                        Text(favoriteManager.favorites.contains(classInfo.name) ? "Følger" : "Følger ikke")
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.FollowButtonStyle())
                
                ButtonAction(systemName: "calendar", titleText: "Historik", destination: CalendarView(classInfo: classInfo))
                
                ButtonAction(systemName: "person.3", titleText: "Elever", destination: StudentListView(selectedClass: classInfo.name))
                
                Spacer()
                
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
                        
                    }
                    .frame(width: 290)
                    .background(Color.frolyRed)
                    .cornerRadius(20)
                    .padding()
                }
                .onAppear() {
                    statisticsManager.fetchClassStats(className: classInfo.name)
                }
                Spacer()
            }
        }
        .navigationTitle(classInfo.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ButtonAction<TargetView: View>: View {
    let systemName: String
    let titleText: String
    let destination: TargetView
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: systemName)
                    .frame(alignment: .leading)
                    .padding(.leading, 20)
                Text(titleText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.leading, -50)
            }
        }
        .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsBold, fontSize: Resources.FontSize.body))
    }
}

struct ClassView_Previews: PreviewProvider {
    static var previews: some View {
        ClassView(classInfo: ClassInfo(name: "", isDoubleRegistrationActivated: false))
    }
}
