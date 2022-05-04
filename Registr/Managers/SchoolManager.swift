//
//  SchoolManager.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import Foundation
import FirebaseFirestore

class SchoolManager: ObservableObject {
    
    @Published var school: School?
    
    // Firestore db reference
    private let db = Firestore.firestore()
    
    // Selectors
    private var selectedSchool: String {
        if let schoolID = UserManager.shared.user?.associatedSchool {
            return schoolID
        } else {
            return ""
        }
    }
    
    init() {
        fetchSchool()
    }
    
    func fetchSchool() {
        db
            .collection("fb_schools_path".localize)
            .getDocuments { querySnapshot, err in
                if let err = err {
                    ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: err.localizedDescription, type: .schoolManagerError)
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            if let schoolSnapshot = try document.data(as: School.self) {
                                self.school = schoolSnapshot
                            }
                        }
                        catch {
                            ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .schoolManagerError)
                        }
                    }
                }
            }
    }
}
