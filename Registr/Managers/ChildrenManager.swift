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
    @Published var absence: [Registration] = []
    
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
    
    func fetchChildrenAbsence(studentID: String) {
        let db = Firestore.firestore()
        
        db
            .collection("fb_students_path")
            .document(studentID)
            .collection("fb_absense_path")
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            if let absence = try document.data(as: Registration.self) {
                                self.absence.append(absence)
                            }
                        } catch {
                            // TODO: Write no children absence and add error view
                            print("No children")
                        }
                    }
                }
            }
    }
}

