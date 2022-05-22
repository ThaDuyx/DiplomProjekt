//
//  GraphSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 06/05/2022.
//

import SwiftUI
import SwiftUICharts

struct GraphSection: View {
    
    @StateObject var statisticsManager = StatisticsViewModel()

    var body: some View {
        if statisticsWeekDay(statistics: statisticsManager).isEmpty || statisticsWeekDay(statistics: statisticsManager).allSatisfy({ $0 == 0 }) {
            Text("stat_no_graph".localize)
                .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                .multilineTextAlignment(.leading)
                .frame(width: 320)
        } else {
            BarChartView(
                data: ChartData(
                    values: chartData(
                        stringArray: WeekDays.allCases.map { $0.rawValue }, 
                        doubleArray: statisticsWeekDay(statistics: statisticsManager).map { Double($0) })), 
                title: "stat_graph_value".localize, 
                legend: "statistics_offenses".localize, 
                style: ChartsStyle.style
            )
        }    
    }
}
