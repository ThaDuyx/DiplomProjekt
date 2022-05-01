//
//  DateRange.swift
//  Registr
//
//  Created by Christoffer Detlef on 20/04/2022.
//

import SwiftUI

let dateRange: ClosedRange<Date> = {
    let calendar = Calendar.current
    let startComponents = DateComponents(year: Calendar.current.component(.year, from: Date()),month: 1, day: 1)
    let endComponents = DateComponents(year: Calendar.current.component(.year, from: Date()), month: 12, day: 31)
    return calendar.date(from:startComponents)!
    ...
    calendar.date(from:endComponents)!
}()

func dateRanges(amountOfDaysSinceStart: Int, amountOfDayssinceStop: Int) -> ClosedRange<Date> {
    let min = Calendar.current.date(byAdding: .day, value: -amountOfDaysSinceStart, to: Date())!
    let max = Calendar.current.date(byAdding: .day, value: -amountOfDayssinceStop + 1, to: Date())!
    return min...max
}

func dateClosedRange(date: Date) -> Int {
    // can be used when we get the real date.
    let date = Calendar.current.startOfDay(for: date)
            
    let components = Calendar.current.dateComponents([.day], from: date, to: .now)
    
    // Force unwraps, since we know that we will have a date, since we have a default value.
    return components.day!
}
