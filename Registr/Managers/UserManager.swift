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
    var children: [Student] = []
    let db = Firestore.firestore()
    
    private init() {}
    
    func fetchChildren(parentID: String, completionHandler: @escaping ([Student]) -> ()) {
        db
            .collection("fb_parent_path".localize)
            .document(parentID)
            .collection("fb_children_path".localize)
            .getDocuments() {  (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    
                } else {
                    for document in querySnapshot!.documents {
                        let childID = document.documentID
                        self.db.collection("fb_students_path".localize).document(childID).getDocument { childDoc, error in
                            if let data = childDoc {
                                do {
                                    if let child = try data.data(as: Student.self) {
                                        self.children.append(child)
                                        completionHandler(self.children)
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
    }
}
