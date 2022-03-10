//
//  RegistrationManager.swift
//  Registr
//
//  Created by Simon Andersen on 10/03/2022.
//

import Foundation
import FirebaseFirestore

struct RegistrationManager {
    
    func fetchRegistrations() {
        let db = Firestore.firestore()
        let docRef = db.collection("classes").document("0.x").collection("registrations").document("11-03-2022")
        docRef.getDocument() { (document, error) in
            if let document = document, document.exists {
                
                do {
                    if let registrationList = try document.data(as: RegistrationList.self) {
                        print(registrationList)
                    }
                }
                catch {
                    print(error)
                }
                
                
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
}
