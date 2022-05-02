//
//  StatisticsManager.swift
//  Registr
//
//  Created by Simon Andersen on 18/04/2022.
//

import Foundation
import FirebaseFirestore

class StatisticsManager: ObservableObject {
    
    // Enums for Weekdays and absences reasons
    enum WeekDays: String, CaseIterable {
        case mon = "Man"
        case tue = "Tir"
        case wed = "Ons"
        case thu = "Tor"
        case fri = "Fre"
    }

    enum AbsencesReasons: String, CaseIterable {
        case late = "For sent"
        case sick = "Syg"
        case legal = "Lovligt"
        case illegal = "Ulovligt"
    }

    // Firestore db reference
    private let db = Firestore.firestore()
    
    // Collection of Firestore write actions
    private var batch = Firestore.firestore().batch()
    
    // The school that the user is accociated with
    private var selectedSchool: String {
        if let schoolID = UserManager.shared.user?.associatedSchool {
            return schoolID
        } else {
            return ""
        }
    }
    
    // Object that contains statistic data and overrides every time it is written to.
    @Published var statistic = Statistics(illegalMorning: 0, illegalAfternoon: 0, illnessMorning: 0, illnessAfternoon: 0, lateMorning: 0, lateAfternoon: 0, legalMorning: 0, legalAfternoon: 0)
    
    // Constants
    private let increment: Int64 = 1
    private let decrement: Int64 = -1
    
    // Counters
    private var illegalCounter: Int64 = 0
    private var illnessCounter: Int64 = 0
    private var lateCounter: Int64 = 0
    
    // MARK: - Student Statistics
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
     
     - parameter oldValue:      The old value of the registration.
     - parameter newValue:      The new value of the registration.
     - parameter studentID:     The selected student's firestore id.
     - parameter isMorning:      A boolean value that determines wether to update the morning or afternoon statistics.
     */
    func updateStudentStatistics(oldValue: String, newValue: String, studentID: String, isMorning: Bool) {
        let studentStatRef = db
            .collection("fb_students_path".localize)
            .document(studentID)
            .collection("fb_statistics_path".localize)
            .document("fb_statistics_doc".localize)
        
        determineAbsence(docRef: studentStatRef, value: newValue, inOrDecrement: increment, isMorning: isMorning)
        
        if !oldValue.isEmpty {
            determineAbsence(docRef: studentStatRef, value: oldValue, inOrDecrement: decrement, isMorning: isMorning)
        }
    }
    
    /**
     Determines wether to increment or decrement either the illegal, illness or late variable in the database.
     
     - parameter docRef:           Reference to the specific student's stats
     - parameter value:            The value to be determined; illegal, illness or late
     - parameter inOrDecrement:    A constant that chooses either to increment or decrement the number in the database.
     - parameter isMorning:        A boolean value that determines wether to update the morning or afternoon statistics.
     */
    private func determineAbsence(docRef: DocumentReference, value: String, inOrDecrement: Int64, isMorning: Bool) {
        switch value {
        case AbsenceReasons.illegal.rawValue:
            batch.updateData([isMorning ? "illegalMorning" : "illegalAfternoon" : FieldValue.increment(inOrDecrement)], forDocument: docRef)
        case AbsenceReasons.illness.rawValue:
            batch.updateData([isMorning ? "illnessMorning" : "illnessAfternoon" : FieldValue.increment(inOrDecrement)], forDocument: docRef)
        case AbsenceReasons.late.rawValue:
            batch.updateData([isMorning ? "lateMorning" : "lateAfternoon" : FieldValue.increment(inOrDecrement)], forDocument: docRef)
        default:
            break
        }
    }

    /// Fetches the statistic variables for a specific student
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
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
    }
    
    // MARK: - Class Statistics
    /// Fetches the statistic variables for a specific class
    func fetchClassStats(className: String) {
        db
            .collection("fb_schools_path".localize)
            .document(selectedSchool)
            .collection("fb_classes_path".localize)
            .document(className)
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
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
    }
    
    func resetStatCounters() {
        illnessCounter = 0; illegalCounter = 0; lateCounter = 0
    }
    
    /**
     Function that writes the calculated statistcs to the specific class
     
     - parameter className:      Name of the selected class.
     - parameter isMorning:      A boolean value that determines wether to update the morning or afternoon statistics.
     */
    func writeClassStats(className: String, isMorning: Bool) {
        let statisticsClassRef = db
            .collection("fb_schools_path".localize)
            .document(selectedSchool)
            .collection("fb_classes_path".localize)
            .document(className)
            .collection("fb_statistics_path".localize)
            .document("fb_statistics_doc".localize)
        
        // If one of the following counters are zero we do not want to use them
        if illegalCounter != 0 {
            statisticsClassRef.updateData([isMorning ? "illegalMorning" : "illegalAfternoon" : FieldValue.increment(illegalCounter)])
        }
        
        if illnessCounter != 0 {
            statisticsClassRef.updateData([isMorning ? "illnessMorning" : "illnessAfternoon" : FieldValue.increment(illnessCounter)])
        }
        
        if lateCounter != 0 {
            statisticsClassRef.updateData([isMorning ? "lateMorning" : "lateAfternoon" : FieldValue.increment(lateCounter)])
        }
    }
    
    /**
     Function that  increments or decrements to the global counters in this class.
     
     - parameter oldValue:       The deselected value of the absence change that we need to use to decrement the global counters
     - parameter newValue:       The newly chosen value of the absence  that we need to use to increment the global counters
     */
    func updateClassStatistics(oldValue: String, newValue: String) {
        // We are incrementing the respective counters
        incrementCounters(value: newValue)
        
        // If the new value is empty and old is not, it means we have removed a field and do not have to increment.
        if !oldValue.isEmpty {
            decrementCounters(value: oldValue)
        }
    }
    
    private func incrementCounters(value: String) {
        switch value {
        case AbsenceReasons.illegal.rawValue:
            illegalCounter += increment
        case AbsenceReasons.illness.rawValue:
            illnessCounter += increment
        case AbsenceReasons.late.rawValue:
            lateCounter += increment
        default:
            break
        }
    }
    
    private func decrementCounters(value: String) {
        switch value {
        case AbsenceReasons.illegal.rawValue:
            illegalCounter += decrement
        case AbsenceReasons.illness.rawValue:
            illnessCounter += decrement
        case AbsenceReasons.late.rawValue:
            lateCounter += decrement
        default:
            break
        }
    }
}
