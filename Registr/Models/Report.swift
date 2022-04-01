//
//  Report.swift
//  Registr
//
//  Created by Simon Andersen on 09/03/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Report: Codable, Hashable {
    @DocumentID var id: String?
    let parentName: String
    let parentID: String
    let studentName: String
    let studentID: String
    let className: String
    let date: Date
    let endDate: Date?
    let description: String?
    let reason: String
    let validated: Bool
    let teacherValidation: String
}
