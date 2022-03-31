//
//  Date+Extensions.swift
//  Registr
//
//  Created by Simon Andersen on 24/03/2022.
//

import Foundation

extension Date {
    
    var currentDateFormatted: String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentDateFormatted = dateFormatter.string(from: currentDate)
        
        return currentDateFormatted
    }
    
    // TODO: Will be deleted in the near future when our dates in the database is how we want them to be
    func formatSpecificData(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentDateFormatted = dateFormatter.string(from: date)
        
        return currentDateFormatted
    }
    // ------------------------------------------------------------------------
    
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
}
