//
//  Absence.swift
//  Registr
//
//  Created by Simon Andersen on 09/03/2022.
//

import Foundation

struct Absence: Codable {
    let date: Date
    let value: String
    let validated: Bool
}
