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
}
