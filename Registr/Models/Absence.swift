//
//  Absence.swift
//  Registr
//
//  Created by Simon Andersen on 09/03/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Absence: Codable {
    @DocumentID var id: String?
    let studentID: String
    let studentName: String
    let date: Date
    let reason: String
    let validated: Bool
}
