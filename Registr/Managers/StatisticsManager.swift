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
    @Published var statistic = Statistics(illegalMorning: 0, illegalAfternoon: 0, illnessMorning: 0, illnessAfternoon: 0, lateMorning: 0, lateAfternoon: 0, legalMorning: 0, legalAfternoon: 0, mon: 0, tue: 0, wed: 0, thu: 0, fri: 0)
    
    // Object for the ErrorType, used to present an error view.
    @Published var appError: ErrorType? = nil
    
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
                self.appError = ErrorType(title: "alert_title".localize, description: err.localizedDescription, type: .statisticsManagerError)
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
     - parameter isMorning:     A boolean value that determines wether to update the morning or afternoon statistics.
     - parameter date:          Date to determine which day we will add to the overall statistics.
     */
    func updateStudentStatistics(oldValue: String, newValue: String, studentID: String, isMorning: Bool, date: Date) {
        let studentStatRef = db
            .collection("fb_students_path".localize)
            .document(studentID)
            .collection("fb_statistics_path".localize)
            .document("fb_statistics_doc".localize)
        
        // Determining statistics for the absence reason
        determineAbsence(docRef: studentStatRef, value: newValue, inOrDecrement: increment, isMorning: isMorning)
        if !oldValue.isEmpty {
            determineAbsence(docRef: studentStatRef, value: oldValue, inOrDecrement: decrement, isMorning: isMorning)
        }
        
        // Determining statistics for the day
        if newValue.isEmpty {
            determineAbsenceDay(docRef: studentStatRef, inOrDecrement: decrement, date: date)
        } else {
            determineAbsenceDay(docRef: studentStatRef, inOrDecrement: increment, date: date)
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
    
    /**
     Determines wether to increment or decrement either the mon, tue, wed, thu or fri variable in the database.
     
     - parameter docRef:           Reference to the specific student's stats
     - parameter inOrDecrement:    A constant that chooses either to increment or decrement the number in the database.
     - parameter date:             The day chosen to open the AbsenceRegistrationView.
     */
    private func determineAbsenceDay(docRef: DocumentReference, inOrDecrement: Int64, date: Date) {
        let day = date.dayOfDate
        switch day {
        case WeekDays.mon.rawValue:
            batch.updateData(["mon" : FieldValue.increment(inOrDecrement)], forDocument: docRef)
        case WeekDays.tue.rawValue:
            batch.updateData(["tue" : FieldValue.increment(inOrDecrement)], forDocument: docRef)
        case WeekDays.wed.rawValue:
            batch.updateData(["wed" : FieldValue.increment(inOrDecrement)], forDocument: docRef)
        case WeekDays.thu.rawValue:
            batch.updateData(["thu" : FieldValue.increment(inOrDecrement)], forDocument: docRef)
        case WeekDays.fri.rawValue:
            batch.updateData(["fri" : FieldValue.increment(inOrDecrement)], forDocument: docRef)
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
                    self.appError = ErrorType(title: "alert_title".localize, description: err.localizedDescription, type: .statisticsManagerError)
                } else {
                    if let document = document {
                        do {
                            if let newStat = try document.data(as: Statistics.self) {
                                self.statistic = newStat
                            }
                        }
                        catch {
                            self.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .statisticsManagerError)
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
                    self.appError = ErrorType(title: "alert_title".localize, description: err.localizedDescription, type: .statisticsManagerError)
                } else {
                    if let document = document {
                        do {
                            if let newStat = try document.data(as: Statistics.self) {
                                self.statistic = newStat
                            }
                        }
                        catch {
                            self.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .statisticsManagerError)
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
    func writeClassStats(className: String, isMorning: Bool, date: Date) {
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
            calculateDayOfAbsenceInClass(docRef: statisticsClassRef, counter: illegalCounter, date: date)
        }
        
        if illnessCounter != 0 {
            statisticsClassRef.updateData([isMorning ? "illnessMorning" : "illnessAfternoon" : FieldValue.increment(illnessCounter)])
            calculateDayOfAbsenceInClass(docRef: statisticsClassRef, counter: illnessCounter, date: date)
        }
        
        if lateCounter != 0 {
            statisticsClassRef.updateData([isMorning ? "lateMorning" : "lateAfternoon" : FieldValue.increment(lateCounter)])
            calculateDayOfAbsenceInClass(docRef: statisticsClassRef, counter: lateCounter, date: date)
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
    
    /**
     Function that updates the class statistics collection with the specific day of the week.
     
     - parameter docRef:         The document reference from the selected class statistcs collection.
     - parameter counter:        One of three counters in this manager class; illegalCounter, illnessCounter or lateCounter.
     - parameter date:           The date of the selected registration.
     */
    private func calculateDayOfAbsenceInClass(docRef: DocumentReference, counter: Int64, date: Date) {
        let day = date.dayOfDate
        switch day {
        case WeekDays.mon.rawValue:
            docRef.updateData(["mon" : FieldValue.increment(counter)])
        case WeekDays.tue.rawValue:
            docRef.updateData(["tue" : FieldValue.increment(counter)])
        case WeekDays.wed.rawValue:
            docRef.updateData(["wed" : FieldValue.increment(counter)])
        case WeekDays.thu.rawValue:
            docRef.updateData(["thu" : FieldValue.increment(counter)])
        case WeekDays.fri.rawValue:
            docRef.updateData(["fri" : FieldValue.increment(counter)])
        default:
            break
        }
    }
}
