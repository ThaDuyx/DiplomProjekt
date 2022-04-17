//
//  UserManager.swift
//  Registr
//
//  Created by Simon Andersen on 02/03/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserManager {
    static let shared = UserManager()
    var user: UserProfile?
}
