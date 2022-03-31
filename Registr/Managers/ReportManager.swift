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
    
    func validateReport(report: Report, validationReason: String, teacherValidation: String) {
        let db = Firestore.firestore()
        let batch = db.batch()
        
        let classAbsenceRef = db
            .collection("fb_classes_path")
            .document(report.className)
            .collection("fb_date_path")
            .document(Date().formatSpecificData(date: report.date))
            .collection("fb_registrations_path")
            .document(report.studentID)
        
        let studentAbsenceRef = db
            .collection("fb_students_path")
            .document(report.studentID)
            .collection("fb_absense_path")
            .document(Date().formatSpecificData(date: report.date))
        
        let parentReportRef = db
            .collection("fb_parent_path")
            .document(DefaultsManager.shared.currentProfileID)
            .collection("fb_report_path")
            .document(Date().formatSpecificData(date: report.date))
        
        batch.updateData(["reason" : validationReason], forDocument: classAbsenceRef)
        batch.updateData(["reason" : validationReason, "validation" : true], forDocument: studentAbsenceRef)
        batch.updateData(["teacherValidation" : teacherValidation], forDocument: parentReportRef)
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
    
    func denyReport(report: Report, teacherValidation: String) {
        let db = Firestore.firestore()
        let batch = db.batch()
        
        let parentReportRef = db
            .collection("fb_parent_path")
            .document(DefaultsManager.shared.currentProfileID)
            .collection("fb_report_path")
            .document(Date().formatSpecificData(date: report.date))
       
        if let id = report.id {
            let classReportRef = db
                .collection("fb_classes_path")
                .document(report.className)
                .collection("fb_report_path")
                .document(id)
            batch.deleteDocument(classReportRef)
        }
        
        
        batch.updateData(["teacherValidation" : teacherValidation], forDocument: parentReportRef)
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
}
