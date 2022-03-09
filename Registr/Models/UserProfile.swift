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
    var children: [Children]?
    var favorites: [Favorite]?
    
    init(uid: String, email: String, name: String, role: Role, children: [Children]?, favorites: [Favorite]?) {
        self.uid = uid
        self.email = email
        self.name = name
        self.role = role
        self.children = children
        self.favorites = favorites
    }
}

struct Children {
    var id: String
}

struct Favorite {
    var className: String
}
