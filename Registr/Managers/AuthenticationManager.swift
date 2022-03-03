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
        // TODO: Add View change
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("general_error" + error.localizedDescription)
                return
                
            } else {
                if let id = authResult?.user.uid, let email = authResult?.user.email {
                    UserManager.shared.user?.email = email
                    print(id)
                    print(email)
                    // Retrieve data from Firestore parent collection
                    let db = Firestore.firestore()
                    switch type {
                    case .parent:
                        let docRef = db.collection("fb_parent_path".localize).document(id)
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                                print("Document data: \(dataDescription)")
                            } else {
                                print("Document does not exist")
                            }
                        }
                        
                    case .school:
                        // TODO: Add teacher and headmaster collection in Firestore
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
