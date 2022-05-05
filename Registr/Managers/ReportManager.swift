//
//  ReportManager.swift
//  Registr
//
//  Created by Simon Andersen on 10/03/2022.
//

import Foundation
import FirebaseFirestore

enum StatisticTime: String {
    case morning = "Morning"
    case afternoon = "Afternoon"
}

class ReportManager: ObservableObject {
    
    // Container for our reports
    @Published var reports = [Report]()
    
    // Container that keeps track of our snapshot listeners in order to detach when not in use anymore.
    private var snapshotListeners = [SnapshotData]()
    
    // The school that the user is accociated with
    private var selectedSchool: String {
        if let schoolID = UserManager.shared.user?.associatedSchool {
            return schoolID
        } else {
            return ""
        }
    }
    
    // Firestore reference
    let db = Firestore.firestore()
    
    init() {
        attachReportListeners()
    }
    
    /**
     Attaches a snapshotlistener for all reports from the user selected favorites
     */
    func attachReportListeners() {
        for favorite in DefaultsManager.shared.favorites {
            let listener = db
                .collection("fb_schools_path".localize)
                .document(selectedSchool)
                .collection("fb_classes_path".localize)
                .document(favorite)
                .collection("fb_report_path".localize)
                .addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: err.localizedDescription, type: .reportMangerInitError)
                    } else {
                        guard let snapshot = querySnapshot else {
                            ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: err!.localizedDescription, type: .reportMangerInitError)
                            return
                        }
                        
                        snapshot.documentChanges.forEach { diff in
                            // When a document has been added we will add the new report to our list
                            if (diff.type == .added) {
                                do {
                                    if let report = try diff.document.data(as: Report.self) {
                                        self.reports.append(report)
                                        self.reports.sort{ $0.className < $1.className }
                                    }
                                }
                                catch {
                                    ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .reportMangerInitError)
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
                                    ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .reportMangerInitError)
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
                                    ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .reportMangerInitError)
                                }
                            }
                        }
                    }
                }
            
            // We add the snapshotlistener to our list of references so we can uniquely identify them.
            snapshotListeners.append(SnapshotData(favoriteName: favorite, listenerRegistration: listener))
            
        }
    }
    
    /**
     When we add a new class favorite we add the snapshot listener for that class.
     
     - parameter newFavorite:       A string on the name of the selected favorite class.
     */
    func addFavorite(newFavorite: String) {
        let listener = db
            .collection("fb_schools_path".localize)
            .document(selectedSchool)
            .collection("fb_classes_path".localize)
            .document(newFavorite)
            .collection("fb_report_path".localize)
            .addSnapshotListener { querySnapshot, err in
                if let err = err {
                    ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: err.localizedDescription, type: .reportManagerError)
                } else {
                    guard let snapshot = querySnapshot else {
                        ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: err!.localizedDescription, type: .reportManagerError)
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
                                ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .reportManagerError)
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
                                ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .reportManagerError)
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
                                ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .reportManagerError)
                            }
                        }
                    }
                }
            }
        
        // We add the snapshotlistener to our list of references so we can uniquely identify them.
        snapshotListeners.append(SnapshotData(favoriteName: newFavorite, listenerRegistration: listener))
    }
    
    /**
     If we remove a favorite, we will also remove all the objects within that class from our list.
     
     - parameter favorite:       A string on the name of the deselected favorite class.
     */
    func removeFavorite(favorite: String) {
        if !DefaultsManager.shared.favorites.contains(favorite) {
            reports.removeAll(where: { $0.className == favorite })
            
            if let index = snapshotListeners.firstIndex(where: { $0.favoriteName == favorite }) {
                snapshotListeners[index].listenerRegistration.remove()
                snapshotListeners.remove(at: index)
            }
        }
    }
    
    /**
     Validates the currently selected report and adds the selected reason to the database.
     
     - parameter selectedReport:       The selected report from the list of reports.
     - parameter validationReason:     The reason selected from the user; illness, late, or illegal.
     - parameter teacherValidation:    The teachers validation on the report, this will be 'Accepted' since we are validating.
     - parameter completion:           A Callback that returns if the write to the database went through.
     */
    func validateReport(selectedReport: Report, validationReason: RegistrationType, teacherValidation: TeacherValidation, completion: @escaping (Bool) -> ()) {
        let batch = db.batch()
        
        if let id = selectedReport.id {
            let date = selectedReport.date.formatSpecificDate(date: selectedReport.date)
            
            switch selectedReport.timeOfDay {
            case .morning:
                // MARK: - Updating morning registration in class collection
                let classMorningAbsenceRef = db
                    .collection("fb_schools_path".localize)
                    .document(selectedSchool)
                    .collection("fb_classes_path".localize)
                    .document(selectedReport.classID)
                    .collection("fb_date_path".localize)
                    .document(date)
                    .collection("fb_morningRegistration_path".localize)
                    .document(selectedReport.studentID)
                
                batch.updateData(["reason" : validationReason.rawValue, "isAbsenceRegistered" : true], forDocument: classMorningAbsenceRef)
                
                // MARK: - Updating morning absence in student collection and creates a new if it does not exist
                let absenceStudentRef = db
                    .collection("fb_students_path".localize)
                    .document(selectedReport.studentID)
                    .collection("fb_absense_path".localize)
                    .whereField("date", isEqualTo: date)
                    .whereField("isMorning", isEqualTo: true)
                
                absenceStudentRef
                    .getDocuments { querySnapshot, err in
                        if err != nil {
                            completion(false)
                        } else {
                            if let querySnapshot = querySnapshot {
                                // If the query snapshot is empty we will create the absence
                                if !querySnapshot.isEmpty {
                                    for document in querySnapshot.documents {
                                        do {
                                            if let registration = try document.data(as: Registration.self) {
                                                self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: registration.studentID, oldReason: registration.reason.rawValue, newReason: validationReason.rawValue, time: .morning, isNewAbsence: false, date: registration.date.dateFromString)
                                                
                                                document.reference.updateData(["reason" : validationReason])
                                            }
                                        } catch {
                                            completion(false)
                                        }
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
                                        let newAbsenceRef = try self.db
                                            .collection("fb_students_path".localize)
                                            .document(selectedReport.studentID)
                                            .collection("fb_absense_path".localize)
                                            .addDocument(from: newAbsence)
                                        print("A new absence were created: \(newAbsenceRef)")
                                        
                                        self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: newAbsence.studentID, oldReason: newAbsence.reason.rawValue, newReason: validationReason.rawValue, time: .morning, isNewAbsence: true, date: date.dateFromString)
                                    } catch {
                                        completion(false)
                                    }
                                }
                            }
                        }
                    }
                
            case .afternoon:
                // MARK: - Updating afternoon registration in class collection
                let classAfternoonAbsenceRef = db
                    .collection("fb_schools_path".localize)
                    .document(selectedSchool)
                    .collection("fb_classes_path".localize)
                    .document(selectedReport.classID)
                    .collection("fb_date_path".localize)
                    .document(date)
                    .collection("fb_afternoonRegistration_path".localize)
                    .document(selectedReport.studentID)
                
                batch.updateData(["reason" : validationReason.rawValue, "isAbsenceRegistered" : true], forDocument: classAfternoonAbsenceRef)
                
                // MARK: - Updating afternoon absence in student collection and creates a new if it does not exist
                let absenceStudentRef = db
                    .collection("fb_students_path".localize)
                    .document(selectedReport.studentID)
                    .collection("fb_absense_path".localize)
                    .whereField("date", isEqualTo: date)
                    .whereField("isMorning", isEqualTo: false)
                
                absenceStudentRef
                    .getDocuments { querySnapshot, err in
                        if err != nil {
                            completion(false)
                        } else {
                            if let querySnapshot = querySnapshot {
                                // If the query snapshot is empty we will create the absence
                                if !querySnapshot.isEmpty {
                                    for document in querySnapshot.documents {
                                        do {
                                            if let registration = try document.data(as: Registration.self) {
                                                self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: registration.studentID, oldReason: registration.reason.rawValue, newReason: validationReason.rawValue, time: .afternoon, isNewAbsence: false, date: registration.date.dateFromString)
                                                
                                                document.reference.updateData(["reason" : validationReason.rawValue])
                                            }
                                        } catch {
                                            completion(false)
                                        }
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
                                        let newAbsenceRef = try self.db
                                            .collection("fb_students_path".localize)
                                            .document(selectedReport.studentID)
                                            .collection("fb_absense_path".localize)
                                            .addDocument(from: newAbsence)
                                        print("A new absence were created: \(newAbsenceRef)")
                                        
                                        self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: newAbsence.studentID, oldReason: newAbsence.reason.rawValue, newReason: validationReason.rawValue, time: .afternoon, isNewAbsence: true, date: date.dateFromString)
                                    } catch {
                                        completion(false)
                                    }
                                }
                            }
                        }
                    }
                
            case .allDay:
                // MARK: - Updating morning & afternoon registration in class collection
                let classMorningAbsenceRef = db
                    .collection("fb_schools_path".localize)
                    .document(selectedSchool)
                    .collection("fb_classes_path".localize)
                    .document(selectedReport.classID)
                    .collection("fb_date_path".localize)
                    .document(date)
                    .collection("fb_morningRegistration_path".localize)
                    .document(selectedReport.studentID)
                
                let classAfternoonAbsenceRef = db
                    .collection("fb_schools_path".localize)
                    .document(selectedSchool)
                    .collection("fb_classes_path".localize)
                    .document(selectedReport.classID)
                    .collection("fb_date_path".localize)
                    .document(date)
                    .collection("fb_afternoonRegistration_path".localize)
                    .document(selectedReport.studentID)
                
                batch.updateData(["reason" : validationReason.rawValue, "isAbsenceRegistered" : true], forDocument: classMorningAbsenceRef)
                batch.updateData(["reason" : validationReason.rawValue, "isAbsenceRegistered" : true], forDocument: classAfternoonAbsenceRef)
                
                // MARK: - Updating morning and afternoon absence in student collection and creates a new if it does not exist
                let absenceStudentRef = db
                    .collection("fb_students_path".localize)
                    .document(selectedReport.studentID)
                    .collection("fb_absense_path".localize)
                    .whereField("date", isEqualTo: date)
                
                absenceStudentRef
                    .getDocuments { querySnapshot, err in
                        if err != nil {
                            completion(false)
                        } else {
                            if let querySnapshot = querySnapshot {
                                // If the query snapshot is empty we will create the absence
                                if !querySnapshot.isEmpty {
                                    for document in querySnapshot.documents {
                                        do {
                                            if let registration = try document.data(as: Registration.self) {
                                                if registration.isMorning {
                                                    self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: registration.studentID, oldReason: registration.reason.rawValue, newReason: validationReason.rawValue, time: .morning, isNewAbsence: false, date: registration.date.dateFromString)
                                                } else {
                                                    self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: registration.studentID, oldReason: registration.reason.rawValue, newReason: validationReason.rawValue, time: .afternoon, isNewAbsence: false, date: registration.date.dateFromString)
                                                }
                                            }
                                        } catch {
                                            completion(false)
                                        }
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
                                        let newMorningAbsenceRef = try self.db
                                            .collection("fb_students_path".localize)
                                            .document(selectedReport.studentID)
                                            .collection("fb_absense_path".localize)
                                            .addDocument(from: newMorningAbsence)
                                        
                                        let newAfternoonAbsenceRef = try self.db
                                            .collection("fb_students_path".localize)
                                            .document(selectedReport.studentID)
                                            .collection("fb_absense_path".localize)
                                            .addDocument(from: newAfternoonAbsence)
                                        print("A new absence were created: \(newMorningAbsenceRef)")
                                        print("A new absence were created: \(newAfternoonAbsenceRef)")
                                        
                                        self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: newMorningAbsence.studentID, oldReason: newMorningAbsence.reason.rawValue, newReason: validationReason.rawValue, time: .morning, isNewAbsence: true, date: date.dateFromString)
                                        self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: newAfternoonAbsence.studentID, oldReason: newAfternoonAbsence.reason.rawValue, newReason: validationReason.rawValue, time: .afternoon, isNewAbsence: true, date: date.dateFromString)
                                    } catch {
                                        completion(false)
                                    }
                                }
                            }
                        }
                    }
                
                let parentReportRef = db
                    .collection("fb_parent_path".localize)
                    .document(selectedReport.parentID)
                    .collection("fb_report_path".localize)
                    .document(id)
                
                let classReportRef = db
                    .collection("fb_schools_path".localize)
                    .document(selectedSchool)
                    .collection("fb_classes_path".localize)
                    .document(selectedReport.classID)
                    .collection("fb_report_path".localize)
                    .document(id)
                
                batch.updateData(["teacherValidation" : teacherValidation.rawValue], forDocument: parentReportRef)
                batch.deleteDocument(classReportRef)
                
                batch.commit() { err in
                    if err != nil {
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
    }
    /**
     Validates the currently selected report and that contains an end date and adds the selected reasons to the respective dates in the database.
     We have split this function with the single date function because it is so large and we would rather be sure to call the for loop one than the single.
     
     - parameter selectedReport:       The selected report from the list of reports.
     - parameter validationReason:     The reason selected from the user; illness, late, or illegal.
     - parameter teacherValidation:    The teachers validation on the report, this will be 'Accepted' since we are validating.
     - parameter completion:           A Callback that returns if the write to the database went through.
     */
    func validateInterval(selectedReport: Report, validationReason: RegistrationType, teacherValidation: TeacherValidation, completion: @escaping (Bool) -> ()) {
        let batch = self.db.batch()
        
        // We will only call this method if the selected report has a endDate.
        if let endDate = selectedReport.endDate {
            let dateInterval = Date.dates(from: selectedReport.date, to: endDate)
            if let id = selectedReport.id {
                // Iteration through the dates
                for date in dateInterval {
                    switch selectedReport.timeOfDay {
                    case .morning:
                        let classMorningAbsenceRef = db
                            .collection("fb_schools_path".localize)
                            .document(selectedSchool)
                            .collection("fb_classes_path".localize)
                            .document(selectedReport.classID)
                            .collection("fb_date_path".localize)
                            .document(date.selectedDateFormatted)
                            .collection("fb_morningRegistration_path".localize)
                            .document(selectedReport.studentID)
                        
                        batch.updateData(["reason" : validationReason.rawValue, "isAbsenceRegistered" : true], forDocument: classMorningAbsenceRef)
                        
                        let absenceStudentRef = db
                            .collection("fb_students_path".localize)
                            .document(selectedReport.studentID)
                            .collection("fb_absense_path".localize)
                            .whereField("date", isEqualTo: date.selectedDateFormatted)
                            .whereField("isMorning", isEqualTo: true)
                        
                        absenceStudentRef
                            .getDocuments { querySnapshot, err in
                                if err != nil {
                                    completion(false)
                                } else {
                                    if let querySnapshot = querySnapshot {
                                        // If the query snapshot is empty we will create the absence
                                        if !querySnapshot.isEmpty {
                                            for document in querySnapshot.documents {
                                                do {
                                                    if let registration = try document.data(as: Registration.self) {
                                                        self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: registration.studentID, oldReason: registration.reason.rawValue, newReason: validationReason.rawValue, time: .morning, isNewAbsence: false, date: registration.date.dateFromString)
                                                        
                                                        document.reference.updateData(["reason" : validationReason.rawValue])
                                                    }
                                                } catch {
                                                    completion(false)
                                                }
                                            }
                                        } else {
                                            let newAbsence = Registration(studentID: selectedReport.studentID,
                                                                          studentName: selectedReport.studentName,
                                                                          className: selectedReport.className,
                                                                          date: date.selectedDateFormatted,
                                                                          reason: validationReason,
                                                                          validated: true,
                                                                          isAbsenceRegistered: true,
                                                                          isMorning: true)
                                            
                                            do {
                                                let newAbsenceRef = try self.db
                                                    .collection("fb_students_path".localize)
                                                    .document(selectedReport.studentID)
                                                    .collection("fb_absense_path".localize)
                                                    .addDocument(from: newAbsence)
                                                print("A new absence were created: \(newAbsenceRef)")
                                                
                                                self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: newAbsence.studentID, oldReason: newAbsence.reason.rawValue, newReason: validationReason.rawValue, time: .morning, isNewAbsence: true, date: date)
                                            } catch {
                                                completion(false)
                                            }
                                        }
                                    }
                                }
                            }
                        
                    case .afternoon:
                        let classAfternoonAbsenceRef = db
                            .collection("fb_schools_path".localize)
                            .document(selectedSchool)
                            .collection("fb_classes_path".localize)
                            .document(selectedReport.classID)
                            .collection("fb_date_path".localize)
                            .document(date.selectedDateFormatted)
                            .collection("fb_afternoonRegistration_path".localize)
                            .document(selectedReport.studentID)
                        
                        batch.updateData(["reason" : validationReason.rawValue, "isAbsenceRegistered" : true], forDocument: classAfternoonAbsenceRef)
                        
                        let absenceStudentRef = db
                            .collection("fb_students_path".localize)
                            .document(selectedReport.studentID)
                            .collection("fb_absense_path".localize)
                            .whereField("date", isEqualTo: date)
                            .whereField("isMorning", isEqualTo: false)
                        
                        absenceStudentRef
                            .getDocuments { querySnapshot, err in
                                if err != nil {
                                    completion(false)
                                } else {
                                    if let querySnapshot = querySnapshot {
                                        // If the query snapshot is empty we will create the absence
                                        if !querySnapshot.isEmpty {
                                            for document in querySnapshot.documents {
                                                do {
                                                    if let registration = try document.data(as: Registration.self) {
                                                        self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: registration.studentID, oldReason: registration.reason.rawValue, newReason: validationReason.rawValue, time: .afternoon, isNewAbsence: false, date: registration.date.dateFromString)
                                                        
                                                        document.reference.updateData(["reason" : validationReason.rawValue])
                                                    }
                                                } catch {
                                                    completion(false)
                                                }
                                            }
                                        } else {
                                            let newAbsence = Registration(studentID: selectedReport.studentID,
                                                                          studentName: selectedReport.studentName,
                                                                          className: selectedReport.className,
                                                                          date: date.selectedDateFormatted,
                                                                          reason: validationReason,
                                                                          validated: true,
                                                                          isAbsenceRegistered: true,
                                                                          isMorning: false)
                                            do {
                                                let newAbsenceRef = try self.db
                                                    .collection("fb_students_path".localize)
                                                    .document(selectedReport.studentID)
                                                    .collection("fb_absense_path".localize)
                                                    .addDocument(from: newAbsence)
                                                print("A new absence were created: \(newAbsenceRef)")
                                                
                                                self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: newAbsence.studentID, oldReason: newAbsence.reason.rawValue, newReason: validationReason.rawValue, time: .afternoon, isNewAbsence: true, date: date)
                                            } catch {
                                                completion(false)
                                            }
                                        }
                                    }
                                }
                            }
                        
                    case .allDay:
                        let classMorningAbsenceRef = db
                            .collection("fb_schools_path".localize)
                            .document(selectedSchool)
                            .collection("fb_classes_path".localize)
                            .document(selectedReport.classID)
                            .collection("fb_date_path".localize)
                            .document(date.selectedDateFormatted)
                            .collection("fb_morningRegistration_path".localize)
                            .document(selectedReport.studentID)
                        
                        let classAfternoonAbsenceRef = db
                            .collection("fb_schools_path".localize)
                            .document(selectedSchool)
                            .collection("fb_classes_path".localize)
                            .document(selectedReport.classID)
                            .collection("fb_date_path".localize)
                            .document(date.selectedDateFormatted)
                            .collection("fb_afternoonRegistration_path".localize)
                            .document(selectedReport.studentID)
                        
                        batch.updateData(["reason" : validationReason.rawValue, "isAbsenceRegistered" : true], forDocument: classMorningAbsenceRef)
                        batch.updateData(["reason" : validationReason.rawValue, "isAbsenceRegistered" : true], forDocument: classAfternoonAbsenceRef)
                        
                        let absenceStudentRef = db
                            .collection("fb_students_path".localize)
                            .document(selectedReport.studentID)
                            .collection("fb_absense_path".localize)
                            .whereField("date", isEqualTo: date)
                        
                        absenceStudentRef
                            .getDocuments { querySnapshot, err in
                                if err != nil {
                                    completion(false)
                                } else {
                                    if let querySnapshot = querySnapshot {
                                        // If the query snapshot is empty we will create the absence
                                        if !querySnapshot.isEmpty {
                                            for document in querySnapshot.documents {
                                                do {
                                                    if let registration = try document.data(as: Registration.self) {
                                                        if registration.isMorning {
                                                            self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: registration.studentID, oldReason: registration.reason.rawValue, newReason: validationReason.rawValue, time: .morning, isNewAbsence: false, date: registration.date.dateFromString)
                                                        } else {
                                                            self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: registration.studentID, oldReason: registration.reason.rawValue, newReason: validationReason.rawValue, time: .afternoon, isNewAbsence: false, date: registration.date.dateFromString)
                                                        }
                                                    }
                                                } catch {
                                                    completion(false)
                                                }
                                            }
                                        } else {
                                            let newMorningAbsence = Registration(studentID: selectedReport.studentID,
                                                                                 studentName: selectedReport.studentName,
                                                                                 className: selectedReport.className,
                                                                                 date: date.selectedDateFormatted,
                                                                                 reason: validationReason,
                                                                                 validated: true,
                                                                                 isAbsenceRegistered: true,
                                                                                 isMorning: true)
                                            
                                            let newAfternoonAbsence = Registration(studentID: selectedReport.studentID,
                                                                                   studentName: selectedReport.studentName,
                                                                                   className: selectedReport.className,
                                                                                   date: date.selectedDateFormatted,
                                                                                   reason: validationReason,
                                                                                   validated: true,
                                                                                   isAbsenceRegistered: true,
                                                                                   isMorning: false)
                                            
                                            do {
                                                let newMorningAbsenceRef = try self.db
                                                    .collection("fb_students_path".localize)
                                                    .document(selectedReport.studentID)
                                                    .collection("fb_absense_path".localize)
                                                    .addDocument(from: newMorningAbsence)
                                                
                                                let newAfternoonAbsenceRef = try self.db
                                                    .collection("fb_students_path".localize)
                                                    .document(selectedReport.studentID)
                                                    .collection("fb_absense_path".localize)
                                                    .addDocument(from: newAfternoonAbsence)
                                                print("A new absence were created: \(newMorningAbsenceRef)")
                                                print("A new absence were created: \(newAfternoonAbsenceRef)")
                                                
                                                self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: newMorningAbsence.studentID, oldReason: newMorningAbsence.reason.rawValue, newReason: validationReason.rawValue, time: .morning, isNewAbsence: true, date: date)
                                                self.updateStudentAndClassStats(classID: selectedReport.classID, studentID: newAfternoonAbsence.studentID, oldReason: newAfternoonAbsence.reason.rawValue, newReason: validationReason.rawValue, time: .afternoon, isNewAbsence: true, date: date)
                                            } catch {
                                                completion(false)
                                            }
                                        }
                                    }
                                }
                            }
                    }
                }
                
                let parentReportRef = db
                    .collection("fb_parent_path".localize)
                    .document(selectedReport.parentID)
                    .collection("fb_report_path".localize)
                    .document(id)
                
                let classReportRef = db
                    .collection("fb_schools_path".localize)
                    .document(selectedSchool)
                    .collection("fb_classes_path".localize)
                    .document(selectedReport.classID)
                    .collection("fb_report_path".localize)
                    .document(id)
                
                batch.updateData(["teacherValidation" : teacherValidation.rawValue], forDocument: parentReportRef)
                batch.deleteDocument(classReportRef)
                
                batch.commit() { err in
                    if err != nil {
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
    }
    
    /**
     Denies the currently selected report and adds the teacher validation to the parents report.
     
     - parameter selectedReport:       The selected report from the list of reports.
     - parameter teacherValidation:    The teachers validation on the report, this will be 'Denied' since we are denying the report.
     - parameter completion:           A Callback that returns if the write to the database went through.
     */
    func denyReport(selectedReport: Report, teacherValidation: TeacherValidation, completion: @escaping (Bool) -> ()) {
        let batch = self.db.batch()
        
        if let id = selectedReport.id {
            let classReportRef = db
                .collection("fb_schools_path".localize)
                .document(selectedSchool)
                .collection("fb_classes_path".localize)
                .document(selectedReport.classID)
                .collection("fb_report_path".localize)
                .document(id)
            
            let parentReportRef = db
                .collection("fb_parent_path".localize)
                .document(selectedReport.parentID)
                .collection("fb_report_path".localize)
                .document(id)
            
            batch.deleteDocument(classReportRef)
            batch.updateData(["teacherValidation" : teacherValidation.rawValue], forDocument: parentReportRef)
            
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
    
    /**
     Updates the statistics tables in both the student and class collections.
     
     - parameter className:       String of the name of the specific class.
     - parameter studentID:       String of the ID of the specific student.
     - parameter oldReason:       The old reason selected of the chosen registration.
     - parameter newReason:       The new reason selected of the chosen registration.
     - parameter time:            Enumeration value of which time of day to choose, either; morning or afternoon
     - parameter isNewAbsence:    Boolean determining wether there already exists an absence in the database.
     - parameter date:            Date used to fetch the day of the registration that has to be updated in the statistcs.
     */
    private func updateStudentAndClassStats(classID: String, studentID: String, oldReason: String, newReason: String, time: StatisticTime, isNewAbsence: Bool, date: Date) {
        let statisticsClassRef = db
            .collection("fb_schools_path".localize)
            .document(selectedSchool)
            .collection("fb_classes_path".localize)
            .document(classID)
            .collection("fb_statistics_path".localize)
            .document("fb_statistics_doc".localize)
        
        let statisticsStudentRef = db
            .collection("fb_students_path".localize)
            .document(studentID)
            .collection("fb_statistics_path".localize)
            .document("fb_statistics_doc".localize)
        
        // If it is a new absence that we are creating in the student collection we do not want to decrement the statistic counters
        if !isNewAbsence {
            switch oldReason {
            case RegistrationType.illegal.rawValue:
                statisticsClassRef.updateData(["illegal\(time.rawValue)" : FieldValue.increment(Int64(-1))])
                statisticsStudentRef.updateData(["illegal\(time.rawValue)" : FieldValue.increment(Int64(-1))])
            case RegistrationType.illness.rawValue:
                statisticsClassRef.updateData(["illness\(time.rawValue)" : FieldValue.increment(Int64(-1))])
                statisticsStudentRef.updateData(["illness\(time.rawValue)" : FieldValue.increment(Int64(-1))])
            case RegistrationType.late.rawValue:
                statisticsClassRef.updateData(["late\(time.rawValue)" : FieldValue.increment(Int64(-1))])
                statisticsStudentRef.updateData(["late\(time.rawValue)" : FieldValue.increment(Int64(-1))])
            case RegistrationType.legal.rawValue:
                statisticsClassRef.updateData(["legal\(time.rawValue)" : FieldValue.increment(Int64(-1))])
                statisticsStudentRef.updateData(["legal\(time.rawValue)" : FieldValue.increment(Int64(-1))])
            default:
                print("")
            }
        }
        
        switch newReason {
        case RegistrationType.illegal.rawValue:
            statisticsClassRef.updateData(["illegal\(time.rawValue)" : FieldValue.increment(Int64(1))])
            statisticsStudentRef.updateData(["illegal\(time.rawValue)" : FieldValue.increment(Int64(1))])
        case RegistrationType.illness.rawValue:
            statisticsClassRef.updateData(["illness\(time.rawValue)" : FieldValue.increment(Int64(1))])
            statisticsStudentRef.updateData(["illness\(time.rawValue)" : FieldValue.increment(Int64(1))])
        case RegistrationType.late.rawValue:
            statisticsClassRef.updateData(["late\(time.rawValue)" : FieldValue.increment(Int64(1))])
            statisticsStudentRef.updateData(["late\(time.rawValue)" : FieldValue.increment(Int64(1))])
        case RegistrationType.legal.rawValue:
            statisticsClassRef.updateData(["legal\(time.rawValue)" : FieldValue.increment(Int64(1))])
            statisticsStudentRef.updateData(["legal\(time.rawValue)" : FieldValue.increment(Int64(1))])
        default:
            print("")
        }
        
        updateDayStatistics(classRef: statisticsClassRef, studentRef: statisticsStudentRef, date: date, increment: 1)
    }
    
    private func updateDayStatistics(classRef: DocumentReference, studentRef: DocumentReference, date: Date, increment: Int64) {
        let day = date.dayOfDate
        switch day {
        case WeekDays.mon.rawValue:
            classRef.updateData(["mon" : FieldValue.increment(increment)])
            studentRef.updateData(["mon" : FieldValue.increment(increment)])
        case WeekDays.tue.rawValue:
            classRef.updateData(["tue" : FieldValue.increment(increment)])
            studentRef.updateData(["tue" : FieldValue.increment(increment)])
        case WeekDays.wed.rawValue:
            classRef.updateData(["wed" : FieldValue.increment(increment)])
            studentRef.updateData(["wed" : FieldValue.increment(increment)])
        case WeekDays.thu.rawValue:
            classRef.updateData(["thu" : FieldValue.increment(increment)])
            studentRef.updateData(["thu" : FieldValue.increment(increment)])
        case WeekDays.fri.rawValue:
            classRef.updateData(["fri" : FieldValue.increment(increment)])
            studentRef.updateData(["fri" : FieldValue.increment(increment)])
        default:
            break
        }
    }
}
