//
//  AuthenticationManager.swift
//  Registr
//
//  Created by Simon Andersen on 02/03/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum signInType{
    case parent
    case school
}

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    func signIn(email: String, password: String, type: signInType)
    {
        // TODO: --- Add View change ---
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                //TODO: --- Insert error view ---
                print("general_error" + error.localizedDescription)
                return
                
            } else {
                if let id = authResult?.user.uid, let email = authResult?.user.email {
                    print(id)
                    print(email)
                    // Retrieve data from Firestore parent collection
                    let db = Firestore.firestore()
                    switch type {
                    case .parent:
                        let docRef = db.collection("fb_parent_path".localize).document(id)
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists, let data = document.data() {
                                let name = data["name"] as? String ?? "nil"
                                let userLoggedIn = UserProfile(uid: id, email: email, name: name, role: .teacher)
                                UserManager.shared.user = userLoggedIn
                                
                            } else {
                                print("Document does not exist")
                            }
                        }
                        
                    case .school:
                        // TODO: --- Add teacher and headmaster collection in Firestore ---
                        print("")
                    }
                    
                    
                }
            }
        }
    }
    
    func signOut()
    {
        do {
            // TODO: Change view to log in screen
            try Auth.auth().signOut()
        } catch {
            print("general_error" + error.localizedDescription)
        }
    }
}
