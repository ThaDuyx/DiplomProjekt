//
//  Class.swift
//  Registr
//
//  Created by Simon Andersen on 21/04/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct ClassInfo: Codable, Hashable {
    @DocumentID var id: String?
    let isDoubleRegistrationActivated: Bool
    let name: String
    let classID: String
}
