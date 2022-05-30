//
//  Date+Extensions.swift
//  Registr
//
//  Created by Simon Andersen on 24/03/2022.
//

import Foundation

extension Date {
    
    var selectedDateFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentDateFormatted = dateFormatter.string(from: self)
        
        return currentDateFormatted
    }
    
    var dayOfDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "da_DK")
        dateFormatter.dateFormat = "E"
        
        let dayOfDate = dateFormatter.string(from: self).dropLast()
        
        return String(dayOfDate).capitalized
    }
    
    func formatSpecificDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentDateFormatted = dateFormatter.string(from: date)
        
        return currentDateFormatted
    }
    
    func formatSpecificToDayAndMonthDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MMM"
        let currentDateFormatted = dateFormatter.string(from: date)
        
        return currentDateFormatted
    }
    
    /// Returns todays date in the format "E d. - dd-MM-yyyy"
    var currentDateAndNameFormatted: String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentDateFormatted = dateFormatter.string(from: currentDate)
        
        dateFormatter.locale = Locale(identifier: "da_DK")
        dateFormatter.dateFormat = "E"
        let currentDayName = dateFormatter.string(from: currentDate).capitalized
        
        let finalCurrentDate = currentDayName + " d. - " + currentDateFormatted
        
        return finalCurrentDate
    }
    
    func comingDays(days: Int) -> [Date] {
        var daysArray: [Date] = []
        for i in 1..<days+1 {
            let date = Calendar.current.date(byAdding: .day, value: i, to: self)!
            daysArray.append(date)
        }
        return daysArray
    }
    
    func previousDays(days: Int) -> [Date] {
        var daysArray: [Date] = []
        for i in 1..<days+1 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: self)!
            daysArray.append(date)
        }
        return daysArray
    }
    
    /// Taken from: https://stackoverflow.com/a/45716411, but modified
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            if !Calendar.current.isDateInWeekend(date) {
                dates.append(date)
            }
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    /// ---------------------------------------------------
}
