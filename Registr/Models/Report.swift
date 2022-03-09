//
//  Report.swift
//  Registr
//
//  Created by Simon Andersen on 09/03/2022.
//

import Foundation

struct Report: Codable {
    let parentName: String
    let parentID: String
    let studentName: String
    let studentID: String
    let date: Date
    let description: String?
    let reason: Reason
}

enum Reason: String, Codable {
    case late = "late"
    case illness = "illness"
    case other = "other"
}
