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
    
    let className: String
    var studentID: String? = nil
    
    // This is for testing the chart
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    init(className: String, studentID: String? = nil) {
        self.className = className
        self.studentID = studentID
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                Button {
                    followAction.toggle()
                    favoriteManager.favoriteAction(favorite: className)
                } label: {
                    
                    HStack {
                        Image(systemName: "checkmark.diamond")
                        
                        Text(favoriteManager.favorites.contains(className) ? "Følger" : "Følger ikke")
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.TransparentFollowButtonStyle())
                
                ButtonAction(systemName: "calendar", titleText: "Historik", destination: CalendarView(className: className))
                
                ButtonAction(systemName: "person.3", titleText: "Elever", destination: StudentListView(selectedClass: className))
                
                Spacer()
                
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
                        
                    }
                    .frame(width: 290)
                    .background(Resources.Color.Colors.frolyRed)
                    .cornerRadius(20)
                    .padding()
                }
                .onAppear() {
                    statisticsManager.fetchClassStats(className: className)
                }
                Spacer()
            }
        }
        .navigationTitle(className)
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
        .buttonStyle(Resources.CustomButtonStyle.FilledBodyTextButtonStyle())
    }
}

struct ClassView_Previews: PreviewProvider {
    static var previews: some View {
        ClassView(className: "0.X")
    }
}
