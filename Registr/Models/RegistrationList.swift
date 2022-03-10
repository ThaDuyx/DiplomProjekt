//
//  Registration.swift
//  Registr
//
//  Created by Simon Andersen on 09/03/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct RegistrationList: Codable {
    @DocumentID var id: String?
    let studentid: Registration
}

struct Registration: Codable {
    let name: String
    let value: String
}
