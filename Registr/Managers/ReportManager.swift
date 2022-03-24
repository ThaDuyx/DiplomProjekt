//
//  ReportManager.swift
//  Registr
//
//  Created by Simon Andersen on 10/03/2022.
//

import Foundation
import FirebaseFirestore

class ReportManager: ObservableObject {
    
    @Published var reports = [Report]()
    
    //TODO: --- We need to implement recieving class string in the method from the view ---
    func fetchReports() {
        let db = Firestore.firestore()
        
        for favorite in DefaultsManager.shared.favorites {
            db
                .collection("classes")
                .document(favorite)
                .collection("reports")
                .getDocuments() {  (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            do {
                                if let report = try document.data(as: Report.self) {
                                    self.reports.append(report)
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
