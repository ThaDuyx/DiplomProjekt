//
//  School.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct School: Codable, Hashable {
    @DocumentID var id: String?
    let startDate: Date
    let endDate: Date
    let name: String
}
