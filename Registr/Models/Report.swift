//
//  Report.swift
//  Registr
//
//  Created by Simon Andersen on 09/03/2022.
//

import Foundation
import FirebaseFirestoreSwift
enum TimeOfDay: String, CaseIterable, Codable {
    case morning = "Morgen"
    case afternoon = "Eftermiddag"
    case allDay = "Hele Dagen"
}

enum TeacherValidation: String, CaseIterable, Codable {
    case accepted = "Godkendt"
    case pending = "Afventer"
    case denied = "Afslået"
}

struct Report: Codable, Hashable {
    @DocumentID var id: String?
    let parentName: String
    let parentID: String
    let studentName: String
    let studentID: String
    let className: String
    let date: Date
    let endDate: Date?
    let timeOfDay: TimeOfDay
    let description: String?
    let reason: String
    let validated: Bool
    let teacherValidation: TeacherValidation
    let isDoubleRegistrationActivated: Bool
}
