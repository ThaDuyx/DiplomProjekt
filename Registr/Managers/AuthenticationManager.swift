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

enum schoolRole {
    case teacher
    case headmaster
}

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    var loginSelection: signInType?
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> ())
    {
        // TODO: --- Add View change ---
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false)
                return
                
            } else {
                if let id = authResult?.user.uid {
                    
                    // Retrieve data from Firestore parent collection
                    let db = Firestore.firestore()
                    switch self.loginSelection {
                    case .parent:
                        let docRef = db.collection("fb_parent_path".localize).document(id)
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                
                                do {
                                    let user = try document.data(as: UserProfile.self)
                                    UserManager.shared.user = user
                                    DefaultsManager.shared.currentProfileID = id
                                    completion(true)
                                } catch {
                                    completion(false)
                                }
                                
                            } else {
                                completion(false)
                            }
                        }
                        
                    case .school:
                        let docRef = db.collection("fb_employee_path".localize).document(id)
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                do {
                                    let user = try document.data(as: UserProfile.self)
                                    UserManager.shared.user = user
                                    DefaultsManager.shared.currentProfileID = id
                                    completion(true)
                                } catch {
                                    completion(false)
                                }
                                
                            } else {
                                completion(false)
                            }
                        }
                        
                    case .none:
                        completion(false)
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
