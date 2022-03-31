//
//  DateFormatter+Extensions.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/03/2022.
//

import Foundation

extension DateFormatter {
    /// Used for formatting dates to E. dd-MM-yyyy
    static let abbreviationDayMonthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "da_DK")
        formatter.dateFormat = "E dd-MM-yyyy"
        return formatter
    }()
}
