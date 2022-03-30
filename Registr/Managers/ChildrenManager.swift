//
//  ChildrenManager.swift
//  Registr
//
//  Created by Simon Andersen on 30/03/2022.
//

import Foundation
import FirebaseFirestore

class ChildrenManager: ObservableObject {
    
    @Published var children: [Student] = []
    
    func fetchChildren(parentID: String) {
        let db = Firestore.firestore()
        
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
                        db.collection("fb_students_path".localize).document(childID).getDocument { childDoc, error in
                            if let data = childDoc {
                                do {
                                    if let child = try data.data(as: Student.self) {
                                        self.children.append(child)
                                        print(child)
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

