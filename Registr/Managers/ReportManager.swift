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
    
    func fetchReports() {
        let db = Firestore.firestore()
        reports.removeAll()
        
        for favorite in DefaultsManager.shared.favorites {
            db
                .collection("fb_classes_path".localize)
                .document(favorite)
                .collection("fb_report_path".localize)
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
        
        if let id = selectedReport.id, let timeOfDay = selectedReport.timeOfDay {
            let date = selectedReport.date.formatSpecificData(date: selectedReport.date)

            switch timeOfDay {
            case "Morgen":
                // MARK: - Updating morning registration in class collection
                let classMorningAbsenceRef = db
                    .collection("fb_classes_path".localize)
                    .document(selectedReport.className)
                    .collection("fb_date_path".localize)
                    .document(date)
                    .collection("fb_morningRegistration_path".localize)
                    .document(selectedReport.studentID)

                batch.updateData(["reason" : validationReason], forDocument: classMorningAbsenceRef)
                
                // MARK: - Updating morning absence in student collection and creates a new if it does not exist
                let absenceStudentRef = db
                    .collection("fb_students_path".localize)
                    .document(selectedReport.studentID)
                    .collection("fb_absense_path".localize)
                    .whereField("date", isEqualTo: date)
                    .whereField("isMorning", isEqualTo: true)
                
                absenceStudentRef.getDocuments { querySnapshot, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        if let querySnapshot = querySnapshot {
                            // If the query snapshot is empty we will create the absence
                            if !querySnapshot.isEmpty {
                                for document in querySnapshot.documents {
                                    document.reference.updateData(["reason" : validationReason])
                                }
                            } else {
                                let newAbsence = Registration(studentID: selectedReport.studentID,
                                                              studentName: selectedReport.studentName,
                                                              className: selectedReport.className,
                                                              date: date,
                                                              reason: validationReason,
                                                              validated: true,
                                                              isAbsenceRegistered: true,
                                                              isMorning: true)
                                
                                do {
                                    let newAbsenceRef = try db
                                        .collection("fb_students_path".localize)
                                        .document(selectedReport.studentID)
                                        .collection("fb_absense_path".localize)
                                        .addDocument(from: newAbsence)
                                    print("A new absence were created: \(newAbsenceRef)")
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                }
            
            case "Eftermiddag":
                // MARK: - Updating afternoon registration in class collection
                let classAfternoonAbsenceRef = db
                    .collection("fb_classes_path".localize)
                    .document(selectedReport.className)
                    .collection("fb_date_path".localize)
                    .document(date)
                    .collection("fb_afternoonRegistration_path".localize)
                    .document(selectedReport.studentID)

                batch.updateData(["reason" : validationReason], forDocument: classAfternoonAbsenceRef)
                
                // MARK: - Updating afternoon absence in student collection and creates a new if it does not exist
                let absenceStudentRef = db
                    .collection("fb_students_path".localize)
                    .document(selectedReport.studentID)
                    .collection("fb_absense_path".localize)
                    .whereField("date", isEqualTo: date)
                    .whereField("isMorning", isEqualTo: false)
                
                absenceStudentRef.getDocuments { querySnapshot, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        if let querySnapshot = querySnapshot {
                            // If the query snapshot is empty we will create the absence
                            if !querySnapshot.isEmpty {
                                for document in querySnapshot.documents {
                                    document.reference.updateData(["reason" : validationReason])
                                }
                            } else {
                                let newAbsence = Registration(studentID: selectedReport.studentID,
                                                              studentName: selectedReport.studentName,
                                                              className: selectedReport.className,
                                                              date: date,
                                                              reason: validationReason,
                                                              validated: true,
                                                              isAbsenceRegistered: true,
                                                              isMorning: false)
                                
                                do {
                                    let newAbsenceRef = try db
                                        .collection("fb_students_path".localize)
                                        .document(selectedReport.studentID)
                                        .collection("fb_absense_path".localize)
                                        .addDocument(from: newAbsence)
                                    print("A new absence were created: \(newAbsenceRef)")
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                }
            
            case "Hele Dagen":
                // MARK: - Updating morning & afternoon registration in class collection
                let classMorningAbsenceRef = db
                    .collection("fb_classes_path".localize)
                    .document(selectedReport.className)
                    .collection("fb_date_path".localize)
                    .document(Date().formatSpecificData(date: selectedReport.date))
                    .collection("fb_morningRegistration_path".localize)
                    .document(selectedReport.studentID)

                let classAfternoonAbsenceRef = db
                    .collection("fb_classes_path".localize)
                    .document(selectedReport.className)
                    .collection("fb_date_path".localize)
                    .document(Date().formatSpecificData(date: selectedReport.date))
                    .collection("fb_afternoonRegistration_path".localize)
                    .document(selectedReport.studentID)

                batch.updateData(["reason" : validationReason], forDocument: classMorningAbsenceRef)
                batch.updateData(["reason" : validationReason], forDocument: classAfternoonAbsenceRef)
                
                // MARK: - Updating morning and afternoon absence in student collection and creates a new if it does not exist
                let absenceStudentRef = db
                    .collection("fb_students_path".localize)
                    .document(selectedReport.studentID)
                    .collection("fb_absense_path".localize)
                    .whereField("date", isEqualTo: date)
                
                absenceStudentRef.getDocuments { querySnapshot, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        if let querySnapshot = querySnapshot {
                            // If the query snapshot is empty we will create the absence
                            if !querySnapshot.isEmpty {
                                for document in querySnapshot.documents {
                                    document.reference.updateData(["reason" : validationReason])
                                }
                            } else {
                                let newMorningAbsence = Registration(studentID: selectedReport.studentID,
                                                              studentName: selectedReport.studentName,
                                                              className: selectedReport.className,
                                                              date: date,
                                                              reason: validationReason,
                                                              validated: true,
                                                              isAbsenceRegistered: true,
                                                              isMorning: true)
                                
                                let newAfternoonAbsence = Registration(studentID: selectedReport.studentID,
                                                                         studentName: selectedReport.studentName,
                                                                         className: selectedReport.className,
                                                                         date: date,
                                                                         reason: validationReason,
                                                                         validated: true,
                                                                         isAbsenceRegistered: true,
                                                                         isMorning: false)
                                
                                do {
                                    let newMorningAbsenceRef = try db
                                        .collection("fb_students_path".localize)
                                        .document(selectedReport.studentID)
                                        .collection("fb_absense_path".localize)
                                        .addDocument(from: newMorningAbsence)
                                    
                                    let newAfternoonAbsenceRef = try db
                                        .collection("fb_students_path".localize)
                                        .document(selectedReport.studentID)
                                        .collection("fb_absense_path".localize)
                                        .addDocument(from: newAfternoonAbsence)
                                    print("A new absence were created: \(newMorningAbsenceRef)")
                                    print("A new absence were created: \(newAfternoonAbsenceRef)")
                                    
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                }
                
            default:
                print("")
            }
            
            let parentReportRef = db
                .collection("fb_parent_path".localize)
                .document(selectedReport.parentID)
                .collection("fb_report_path".localize)
                .document(id)

            let classReportRef = db
                .collection("fb_classes_path".localize)
                .document(selectedReport.className)
                .collection("fb_report_path".localize)
                .document(id)

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
