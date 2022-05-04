//
//  AuthenticationManager.swift
//  Registr
//
//  Created by Simon Andersen on 02/03/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum signInType {
    case parent
    case school
}

class AuthenticationManager {
    
    // Singleton instance
    static let shared = AuthenticationManager()
    
    // Firebase reference
    let db = Firestore.firestore()
    
    // Selector for which login button was pressed on.
    var loginSelection: signInType?
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> ()) {
        // TODO: --- Add View change ---
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                completion(false)
                return
                
            } else {
                if let id = authResult?.user.uid {
                    // Choosing either the parent or employee path
                    let docRef = self.loginSelection == .parent ? self.db.collection("fb_parent_path".localize).document(id) : self.db.collection("fb_employee_path".localize).document(id)
                    
                    // Retrieve data from Firestore parent collection
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            do {
                                let user = try document.data(as: UserProfile.self)
                                UserManager.shared.user = user
                                DefaultsManager.shared.currentProfileID = id
                                if let role = user?.role {
                                    DefaultsManager.shared.userRole = role
                                }
                                completion(true)
                            } catch {
                                completion(false)
                            }
                            
                        } else {
                            completion(false)
                        }
                    }
                }
            }
        }
    }
    
    func signOut(completion: @escaping (Bool) -> ()) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(true)
        } catch _ as NSError {
            completion(false)
        }
    }
}
