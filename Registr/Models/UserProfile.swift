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

struct UserProfile {
    var uid: String
    var email: String
    var name: String
    var role: Role
}
