//
//  UserProfile.swift
//  Registr
//
//  Created by Simon Andersen on 02/03/2022.
//

import Foundation
import FirebaseFirestoreSwift

enum Role: Codable {
    case teacher
    case parent
    case headmaster
}

class UserProfile: Codable {
    @DocumentID var id: String?
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

struct Children: Codable {
    var id: String
}

struct Favorite: Codable {
    var className: String
}
