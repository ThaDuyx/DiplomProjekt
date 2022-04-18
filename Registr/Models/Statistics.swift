//
//  Statistics.swift
//  Registr
//
//  Created by Simon Andersen on 18/04/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Statistics: Codable {
    @DocumentID var id: String?
    let illegal: Int
    let illness: Int
    let late: Int
    let legal: Int
}
