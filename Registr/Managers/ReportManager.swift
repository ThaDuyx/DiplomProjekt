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
    
    init() {
        fetchReports()
    }
    
    //TODO: --- We need to implement recieving class string in the method from the view ---
    func fetchReports() {
        let db = Firestore.firestore()
        reports.removeAll()
        
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
    
    func reportFavoriteAction(favorite: String) {
        if DefaultsManager.shared.favorites.contains(favorite) {
            reports.removeAll(where: { $0.className == favorite })
        }
    }
    
    func validateReport(selectedReport: Report, validationReason: String, teacherValidation: String, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let batch = db.batch()
        
        if let id = selectedReport.id {
            let classAbsenceRef = db
                .collection("fb_classes_path".localize)
                .document(selectedReport.className)
                .collection("fb_date_path".localize)
                .document(Date().formatSpecificData(date: selectedReport.date))
                .collection("fb_registrations_path".localize)
                .document(selectedReport.studentID)
            
            let classReportRef = db
                .collection("fb_classes_path".localize)
                .document(selectedReport.className)
                .collection("fb_report_path".localize)
                .document(id)
                
            
            let studentAbsenceRef = db
                .collection("fb_students_path".localize)
                .document(selectedReport.studentID)
                .collection("fb_absense_path".localize)
                .document(Date().formatSpecificData(date: selectedReport.date))
            
            let parentReportRef = db
                .collection("fb_parent_path".localize)
                .document(DefaultsManager.shared.currentProfileID)
                .collection("fb_report_path".localize)
                .document(Date().formatSpecificData(date: selectedReport.date))
            
            batch.updateData(["reason" : validationReason], forDocument: classAbsenceRef)
            batch.updateData(["reason" : validationReason, "validation" : true], forDocument: studentAbsenceRef)
            batch.updateData(["teacherValidation" : teacherValidation], forDocument: parentReportRef)
            batch.deleteDocument(classReportRef)
            
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                    completion(false)
                } else {
                    print("Batch write succeeded.")
                    completion(true)
                    if let index = self.reports.firstIndex(where: {$0.id == id}) {
                        self.reports.remove(at: index)
                    }
                }
            }
        }
    }
    
    func denyReport(selectedReport: Report, teacherValidation: String, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let batch = db.batch()
        
        if let id = selectedReport.id {
            let classReportRef = db
                .collection("fb_classes_path".localize)
                .document(selectedReport.className)
                .collection("fb_report_path".localize)
                .document(id)
            
            let parentReportRef = db
                .collection("fb_parent_path".localize)
                .document(selectedReport.parentID)
                .collection("fb_report_path".localize)
                .document(id)
            
            batch.deleteDocument(classReportRef)
            batch.updateData(["teacherValidation" : teacherValidation], forDocument: parentReportRef)
            
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                    completion(false)
                } else {
                    print("Batch write succeeded.")
                    if let index = self.reports.firstIndex(where: {$0.id == id}) {
                        self.reports.remove(at: index)
                    }
                    completion(true)
                }
            }
        }
    }
}
