//
//  StatisticsManager.swift
//  Registr
//
//  Created by Simon Andersen on 18/04/2022.
//

import Foundation
import FirebaseFirestore

class StatisticsManager: ObservableObject {
    private let db = Firestore.firestore()
    private var batch = Firestore.firestore().batch()
    private let increment: Int64 = 1
    private let decrement: Int64 = -1
    
    func commitBatch() {
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
    
    func resetBatch() {
        batch = Firestore.firestore().batch()
    }
    
    func addStatWrite(oldValue: String, newValue: String, studentID: String) {
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
