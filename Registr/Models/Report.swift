//
//  Report.swift
//  Registr
//
//  Created by Simon Andersen on 09/03/2022.
//

import Foundation
import FirebaseFirestoreSwift
enum AbsenceType: String, CaseIterable, Codable {
    case illness = "Sygdom"
    case late = "For sent"
    case vacation = "Ferie"
    case prolongedIllness = "Forlænget sygdom"
}

enum TimeOfDay: String, CaseIterable, Codable {
    case morning = "Morgen"
    case afternoon = "Eftermiddag"
    case allDay = "Hele Dagen"
}

enum TeacherValidation: String, CaseIterable, Codable {
    case pending = "Afventer"
    case accepted = "Godkendt"
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
    let reason: AbsenceType
    let registrationType: RegistrationType
    let validated: Bool
    let teacherValidation: TeacherValidation
    let isDoubleRegistrationActivated: Bool
}
