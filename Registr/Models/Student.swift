//
//  Student.swift
//  Registr
//
//  Created by Simon Andersen on 11/03/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Student: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    let name: String
    let className: String
    let email: String
    var classInfo: ClassInfo
}
