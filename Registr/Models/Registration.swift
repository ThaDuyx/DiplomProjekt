//
//  Registration.swift
//  Registr
//
//  Created by Simon Andersen on 09/03/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Registration: Codable {
    @DocumentID var id: String?
    let name: String
    let value: String
}
