//
//  Student.swift
//  Registr
//
//  Created by Simon Andersen on 11/03/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Student {
    @DocumentID var id: String?
    let name: String
}
