//
//  StatisticsManager.swift
//  Registr
//
//  Created by Simon Andersen on 18/04/2022.
//

import Foundation
import FirebaseFirestore

class StatisticsManager: ObservableObject {
    // Firestore db reference
    private let db = Firestore.firestore()
    
    // Collection of Firestore write actions
    private var batch = Firestore.firestore().batch()
    
    // Object that contains data and overrides every time it is written to.
    @Published var statistic = Statistics(illegal: 0, illness: 0, late: 0, legal: 0)
    
    // Constants
    private let increment: Int64 = 1
    private let decrement: Int64 = -1
    
    func fetchClassStats(className: String) {
        db
            .collection("fb_classes_path".localize)
            .document(className)
            .getDocument { document, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let document = document {
                        do {
                            if let newStat = try document.data(as: Statistics.self) {
                                self.statistic = newStat
                            }
                            print(self.statistic)
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
    }
    
    func fetchStudentStats(studentID: String) {
        db
            .collection("fb_students_path".localize)
            .document(studentID)
            .collection("fb_statistics_path".localize)
            .document("fb_statistics_doc".localize)
            .getDocument { document, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let document = document {
                        do {
                            if let newStat = try document.data(as: Statistics.self) {
                                self.statistic = newStat
                            }
                            print(self.statistic)
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
    }
    
    /// Comitting the global batch of writes and will clean every write in the object.
    func commitBatch() {
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }

    /// Resetting the global batch of writes creating a clean object.
    func resetBatch() {
        batch = Firestore.firestore().batch()
    }
    
    /**
     Adds a new write action of the specific student's statistics to the global batch of writes.
     
     - parameter oldValue:      The old value of the registration
     - parameter newValue:      The new value of the registration
     - parameter studentID:     The selected student's firestore id
     */
    func updateStudentStatistics(oldValue: String, newValue: String, studentID: String) {
        let studentStatRef = db
            .collection("fb_students_path".localize)
            .document(studentID)
            .collection("fb_statistics_path".localize)
            .document("fb_statistics_doc".localize)
        
        if oldValue.isEmpty {
            determineAbsence(docRef: studentStatRef, value: newValue, inOrDecrement: increment)
        } else {
            determineAbsence(docRef: studentStatRef, value: newValue, inOrDecrement: increment)
            determineAbsence(docRef: studentStatRef, value: oldValue, inOrDecrement: decrement)
        }
    }
    
    /**
     Determines wether to increment or decrement either the illegal, illness or late variable in the database.
     
     - parameter docRef:           Reference to the specific student's stats
     - parameter value:            The value to be determined; illegal, illness or late
     - parameter inOrDecrement:    A constant that chooses either to increment or decrement the number in the database
     */
    private func determineAbsence(docRef: DocumentReference, value: String, inOrDecrement: Int64) {
        switch value {
        case AbsenceReasons.illegal.rawValue:
            batch.updateData(["illegal" : FieldValue.increment(inOrDecrement)], forDocument: docRef)
        case AbsenceReasons.illness.rawValue:
            batch.updateData(["illness" : FieldValue.increment(inOrDecrement)], forDocument: docRef)
        case AbsenceReasons.late.rawValue:
            batch.updateData(["late" : FieldValue.increment(inOrDecrement)], forDocument: docRef)
        default:
            break
        }
    }
}
