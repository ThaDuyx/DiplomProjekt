//
//  RegistrationManager.swift
//  Registr
//
//  Created by Simon Andersen on 10/03/2022.
//

import Foundation
import FirebaseFirestore

class RegistrationManager: ObservableObject {
    
    @Published var registrations: [Registration]?
    @Published var students: [Student]?
    
    //TODO: --- We need to implement recieving class string in the method from the view - We can make the date logic from this manager class ---
    func fetchRegistrations() {
        let db = Firestore.firestore()
        db
            .collection("classes")
            .document("0.x")
            .collection("fb_date_path".localize)
            .document("12-03-2022")
            .collection("fb_registrations_path".localize)
            .getDocuments() {  (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            if let registration = try document.data(as: Registration.self) {
                                self.registrations?.append(registration)
                                print(registration)
                            }
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
    }
}
