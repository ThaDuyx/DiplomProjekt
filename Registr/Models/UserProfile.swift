//
//  UserProfile.swift
//  Registr
//
//  Created by Simon Andersen on 02/03/2022.
//

import Foundation
import FirebaseFirestoreSwift

enum Role: String, Codable {
    case teacher = "teacher"
    case parent = "parent"
    case headmaster = "headmaster"
    case none = "none"
}

class UserProfile: Codable {
    @DocumentID var id: String?
    var email: String
    var name: String
    var role: Role
    var associatedSchool: String
    
    init(email: String, name: String, role: Role, associatedSchool: String) {
        self.email = email
        self.name = name
        self.role = role
        self.associatedSchool = associatedSchool
    }
}
