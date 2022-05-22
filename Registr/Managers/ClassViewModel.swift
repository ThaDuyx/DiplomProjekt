//
//  ClassManager.swift
//  Registr
//
//  Created by Simon Andersen on 05/05/2022.
//

import Foundation
import FirebaseFirestore

class ClassViewModel: ObservableObject {
    
    @Published var classes = [ClassInfo]()
    
    private let db = Firestore.firestore()
    
    private var selectedSchool: String {
        return DefaultsManager.shared.associatedSchool
    }
    
    init() {
        fetchClasses()
    }
    
    // Retrieves info on every classes in the associated school
    func fetchClasses() {
        db
            .collection("fb_schools_path".localize)
            .document(selectedSchool)
            .collection("fb_classes_path".localize)
            .getDocuments { querySnapshot, err in
                if let err = err {
                    ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: err.localizedDescription, type: .classManagerError)
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            if let classSnapshot = try document.data(as: ClassInfo.self) {
                                self.classes.append(classSnapshot)
                                self.classes.sort{ $0.name < $1.name }
                            }
                        }
                        catch {
                            ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .classManagerError)
                        }
                    }
                }
            }
    }
}
