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
