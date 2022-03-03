//
//  UserProfile.swift
//  Registr
//
//  Created by Simon Andersen on 02/03/2022.
//

import Foundation

enum Role {
    case teacher
    case parent
    case headmaster
}

class UserProfile {
    var uid: String
    var email: String
    var name: String
    var role: Role
    
    init(uid: String, email: String, name: String, role: Role) {
        self.uid = uid
        self.email = email
        self.name = name
        self.role = role
    }
}
