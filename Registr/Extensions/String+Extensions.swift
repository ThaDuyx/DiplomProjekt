//
//  String+Extensions.swift
//  Registr
//
//  Created by Simon Andersen on 03/03/2022.
//

import Foundation

extension String {
    var localize: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// To use this extension the string has to be in the format "dd-MM-yyyy"
    var dateFromString: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateFromString = dateFormatter.date(from: self)
        
        if let dateFromString = dateFromString {
            return dateFromString
        } else {
            return Date()
        }
    }
}
