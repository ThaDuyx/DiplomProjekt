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
    @Published var absences: [Registration] = []
    @Published var reports: [Report] = []
    
    var selectedAbsenceID = String()
    var selectedReportID = String()
    
    init() {
        fetchChildren(parentID: DefaultsManager.shared.currentProfileID)
    }
    
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
        if selectedAbsenceID != studentID {
            selectedAbsenceID = studentID
            absences.removeAll()
            
            let db = Firestore.firestore()
            db
                .collection("fb_students_path".localize)
                .document(selectedAbsenceID)
                .collection("fb_absense_path".localize)
                .getDocuments { querySnapshot, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            do {
                                if let absence = try document.data(as: Registration.self) {
                                    self.absences.append(absence)
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
    
    func createAbsenceReport(child: Student, report: Report, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let batch = db.batch()
        
        let newClassReport = db
            .collection("fb_classes_path".localize)
            .document(child.className)
            .collection("fb_report_path".localize)
            .document()
        
        let newDocID = newClassReport.documentID
        
        let newParentReport = db
            .collection("fb_parent_path".localize)
            .document(DefaultsManager.shared.currentProfileID)
            .collection("fb_report_path".localize)
            .document(newDocID)
        
        do {
            try batch.setData(from: report, forDocument: newClassReport)
            try batch.setData(from: report, forDocument: newParentReport)
        }
        catch {
          print(error)
        }
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
                completion(false)
            } else {
                print("Batch write succeeded.")
                completion(true)
            }
        }
    }
    
    func fetchChildrenReports(childID: String) {
        if selectedReportID != childID {
            selectedReportID = childID
            reports.removeAll()
            let db = Firestore.firestore()
            db
                .collection("fb_parent_path".localize)
                .document(DefaultsManager.shared.currentProfileID)
                .collection("fb_report_path".localize)
                .whereField("studentID", isEqualTo: childID)
                .getDocuments { querySnapshot, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            do {
                                if let report = try document.data(as: Report.self) {
                                    self.reports.append(report)
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
}

