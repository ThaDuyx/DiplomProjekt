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
    var children: [Student]?
    
    init(uid: String, email: String, name: String, role: Role, children: [Student]?) {
        self.uid = uid
        self.email = email
        self.name = name
        self.role = role
        self.children = children
    }
}
