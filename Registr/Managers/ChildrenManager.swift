//
//  ChildrenManager.swift
//  Registr
//
//  Created by Simon Andersen on 30/03/2022.
//

import Foundation
import FirebaseFirestore

class ChildrenManager: ObservableObject {
    
    // Published collection of our data
    @Published var children = [Student]()
    @Published var absences = [Registration]()
    @Published var reports = [Report]()
    
    // Array of the parents children ids, that we use to create snapshot listeners for their absences
    private var childrenIds = [String]()
    
    // Selectors
    var selectedAbsenceID = String()
    var selectedReportID = String()
    
    // Firebase reference
    let db = Firestore.firestore()
    
    init() {
        fetchChildren(parentID: DefaultsManager.shared.currentProfileID) { result in
            if result {
                self.attachAbsenceListeners()
            }
        }
        attachReportListeners()
    }
    
    private func fetchChildren(parentID: String, completion: @escaping (Bool) -> ()) {
        
        db
            .collection("fb_parent_path".localize)
            .document(parentID)
            .collection("fb_children_path".localize)
            .getDocuments() {  (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(false)
                } else {
                    for document in querySnapshot!.documents {
                        let childID = document.documentID
                        self.childrenIds.append(childID)
                        self.db.collection("fb_students_path".localize).document(childID).getDocument { childDoc, error in
                            if let data = childDoc {
                                do {
                                    if let child = try data.data(as: Student.self) {
                                        self.children.append(child)
                                        self.children.sort { $0.className < $1.className }
                                    }
                                }
                                catch {
                                    print(error)
                                }
                            }
                        }
                    }
                    completion(true)
                }
            }
    }
    
    private func attachReportListeners() {
        db
            .collection("fb_parent_path".localize)
            .document(DefaultsManager.shared.currentProfileID)
            .collection("fb_report_path".localize)
            .addSnapshotListener { querySnapshot, err in
                if let err = err {
                    print("Error in subscribing to snapshotListener: \(err)")
                } else {
                    guard let snapshot = querySnapshot else {
                        print("Error fetching snapshots: \(err!)")
                        return
                    }
                    
                    snapshot.documentChanges.forEach { diff in
                        // When a document has been added we will add the new report to our list
                        if (diff.type == .added) {
                            do {
                                if let report = try diff.document.data(as: Report.self) {
                                    self.reports.append(report)
                                }
                            }
                            catch {
                                print(error)
                            }
                        }
                        
                        // When a document has been modified we will fetch the repective report and update its content
                        if (diff.type == .modified) {
                            do {
                                if let modifiedReport = try diff.document.data(as: Report.self) {
                                    if let modifiedId = modifiedReport.id, let index = self.reports.firstIndex(where: {$0.id == modifiedId}) {
                                        self.reports[index] = modifiedReport
                                    }
                                }
                            }
                            catch {
                                print(error)
                            }
                        }
                        
                        // When a document has been removed we will fetch the repective report and removed its content from our list
                        if (diff.type == .removed) {
                            do {
                                if let removedReport = try diff.document.data(as: Report.self) {
                                    if let removedId = removedReport.id, let index = self.reports.firstIndex(where: {$0.id == removedId}) {
                                        self.reports.remove(at: index)
                                    }
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
    
    private func attachAbsenceListeners() {
        for childrenId in childrenIds {
            db
                .collection("fb_students_path".localize)
                .document(childrenId)
                .collection("fb_absense_path".localize)
                .addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error in subscribing to snapshotListener: \(err)")
                    } else {
                        guard let snapshot = querySnapshot else {
                            print("Error fetching snapshots: \(err!)")
                            return
                        }
                        
                        snapshot.documentChanges.forEach { diff in
                            // When a document has been added we will add the new registration to our list
                            if (diff.type == .added) {
                                do {
                                    if let absence = try diff.document.data(as: Registration.self) {
                                        self.absences.append(absence)
                                    }
                                }
                                catch {
                                    print(error)
                                }
                            }
                            
                            // When a document has been modified we will fetch the repective registration and update its content
                            if (diff.type == .modified) {
                                do {
                                    if let modifiedAbsence = try diff.document.data(as: Registration.self) {
                                        if let modifiedId = modifiedAbsence.id, let index = self.absences.firstIndex(where: {$0.id == modifiedId}) {
                                            self.absences[index] = modifiedAbsence
                                        }
                                    }
                                }
                                catch {
                                    print(error)
                                }
                            }
                            
                            // When a document has been removed we will fetch the repective registration and removed its content from our list
                            if (diff.type == .removed) {
                                do {
                                    if let removedAbsence = try diff.document.data(as: Registration.self) {
                                        if let removedId = removedAbsence.id, let index = self.absences.firstIndex(where: {$0.id == removedId}) {
                                            self.absences.remove(at: index)
                                        }
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
}
