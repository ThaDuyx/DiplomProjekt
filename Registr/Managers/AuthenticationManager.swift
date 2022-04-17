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
                //TODO: --- Insert error view ---
                print("general_error" + error.localizedDescription)
                return
                
            } else {
                if let id = authResult?.user.uid, let email = authResult?.user.email {
                    
                    // Retrieve data from Firestore parent collection
                    let db = Firestore.firestore()
                    switch self.loginSelection {
                    case .parent:
                        let docRef = db.collection("fb_parent_path".localize).document(id)
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists, let data = document.data() {
                                let name = data["name"] as? String ?? "nil"
                                let userLoggedIn = UserProfile(uid: id, email: email, name: name, role: .parent)
                                UserManager.shared.user = userLoggedIn
                                DefaultsManager.shared.currentProfileID = id
                                completion(true)
                                
                            } else {
                                print("Document does not exist")
                                completion(false)
                            }
                        }
                        
                        //TODO: --- Add headmaster UserProfile ---
                    case .school:
                        let docRef = db.collection("fb_employee_path".localize).document(id)
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists, let data = document.data() {
                                let name = data["name"] as? String ?? "nil"
                                let roleData = data["role"] as? Bool ?? false
                                let role: Role = roleData ? .headmaster : .teacher
                                let userLoggedIn = UserProfile(uid: id, email: email, name: name, role: role)
                                UserManager.shared.user = userLoggedIn
                                completion(true)
                                
                            } else {
                                print("Document does not exist")
                                completion(false)
                            }
                        }
                        
                    case .none:
                        print("Something went wrong")
                        completion(false)
                    }
                }
            }
        }
    }
    
    func signOut()
    {
        do {
            // TODO: --- Change view to log in screen & probably add a completion handler to this function ---
            try Auth.auth().signOut()
        } catch {
            print("general_error" + error.localizedDescription)
        }
    }
}
