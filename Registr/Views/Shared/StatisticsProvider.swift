//
//  StatisticsProvider.swift
//  Registr
//
//  Created by Christoffer Detlef on 06/05/2022.
//

import SwiftUI

extension View {
    
    func statisticMorning(statistics: StatisticsManager) -> [Int] {
        var morningArray: [Int] = []
        morningArray.append(statistics.statistic.lateMorning)
        morningArray.append(statistics.statistic.illnessMorning)
        morningArray.append(statistics.statistic.legalMorning)
        morningArray.append(statistics.statistic.illegalMorning)
        return morningArray
    }
    
    func statisticAfternoon(statistics: StatisticsManager) -> [Int] {
        var afternoonArray: [Int] = []
        afternoonArray.append(statistics.statistic.lateAfternoon)
        afternoonArray.append(statistics.statistic.illnessAfternoon)
        afternoonArray.append(statistics.statistic.legalAfternoon)
        afternoonArray.append(statistics.statistic.illegalAfternoon)
        return afternoonArray
    }
    
    func statisticsWeekDay(statistics: StatisticsManager) -> [Int] {
        var weekdayArray: [Int] = []
        weekdayArray.append(statistics.statistic.mon)
        weekdayArray.append(statistics.statistic.tue)
        weekdayArray.append(statistics.statistic.wed)
        weekdayArray.append(statistics.statistic.thu)
        weekdayArray.append(statistics.statistic.fri)
        return weekdayArray
    }
    
    func chartData(stringArray: [String], doubleArray: [Double]) -> [(String, Double)] {
        
        let chartArray = Array(zip(stringArray, doubleArray))
        
        return chartArray
    }
}
