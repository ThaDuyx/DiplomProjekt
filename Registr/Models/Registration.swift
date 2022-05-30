//
//  Registration.swift
//  Registr
//
//  Created by Simon Andersen on 09/03/2022.
//

import Foundation
import FirebaseFirestoreSwift

enum RegistrationType: String, CaseIterable, Codable {
    case late = "For sent"
    case illness = "Sygdom"
    case legal = "Lovligt"
    case illegal = "Ulovligt"
    case notRegistered = ""
}

struct Registration: Codable, Hashable {
    @DocumentID var id: String?
    let studentID: String
    let studentName: String
    let className: String
    let date: String
    var reason: RegistrationType = .notRegistered
    let endDate: String?
    var validated: Bool = false
    var isAbsenceRegistered: Bool = false
    var isMorning: Bool
}
