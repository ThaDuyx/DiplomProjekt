//
//  ReportManager.swift
//  Registr
//
//  Created by Simon Andersen on 10/03/2022.
//

import Foundation
import FirebaseFirestore

class ReportManager: ObservableObject {
    
    @Published var reports: [Report]?
    
    func fetchReports() {
        let db = Firestore.firestore()
        db.collection("classes")
            .document("0.x")
            .collection("reports")
            .getDocuments() {  (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            if let report = try document.data(as: Report.self) {
                                self.reports?.append(report)
                                print(report)
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
