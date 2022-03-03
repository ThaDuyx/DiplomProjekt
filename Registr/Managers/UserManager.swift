//
//  UserManager.swift
//  Registr
//
//  Created by Simon Andersen on 02/03/2022.
//

import Foundation

class UserManager {
    
    static let shared = UserManager()
    
    var user: UserProfile?
    
    private init() {}
    
}
