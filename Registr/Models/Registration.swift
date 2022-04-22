//
//  Registration.swift
//  Registr
//
//  Created by Simon Andersen on 09/03/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Registration: Codable, Hashable {
    @DocumentID var id: String?
    let studentID: String
    let studentName: String
    let className: String
    let date: String
    var reason: String = ""
    var validated: Bool = false
    var isAbsenceRegistered: Bool = false
    var isMorning: Bool?
}
