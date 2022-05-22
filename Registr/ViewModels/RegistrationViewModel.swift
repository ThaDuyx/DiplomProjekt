//
//  RegistrationViewModel.swift
//  Registr
//
//  Created by Simon Andersen on 10/03/2022.
//

import Foundation
import FirebaseFirestore

class RegistrationViewModel: ObservableObject {
    
    // Collections
    @Published var registrationInfo = RegistrationInfo()
    @Published var registrations = [Registration]()
    @Published var students = [Student]()
    
    // Firestore db reference
    private let db = Firestore.firestore()
    
    // Selectors
    private var selectedClass = String()
    private var selectedDate = String()
    private var selectedIsMorning: Bool = true
    private var selectedSchool: String {
        return DefaultsManager.shared.associatedSchool
    }
    
    func setAbsenceReason(absenceReason: RegistrationType, index: Int) {
        registrations[index].reason = absenceReason
    }
    
    // MARK: - Firestore actions
    /**
     Fetches all the registration of a selected class and will not fetch repeatedly if the selected class or date has not changed.
     
     - parameter className:      The unique name specifier of the class
     - parameter date:           A date string in the format: dd-MM-yyyy
     - parameter isMorning:      A boolean value that determines to fetch the the morning or afternoon table.
     */
    func fetchRegistrations(classID: String, date: String, isMorning: Bool) {
        // If 'selectedClass' is the same as the className input we have already fetched the registration.
        // In this case will not have to fetch it again.
        if selectedClass != classID || selectedDate != date || selectedIsMorning != isMorning {
            registrations.removeAll()
            registrationInfo = RegistrationInfo()
            selectedClass = classID
            selectedDate = date
            selectedIsMorning = isMorning
            
            db
                .collection("fb_schools_path".localize)
                .document(selectedSchool)
                .collection("fb_classes_path".localize)
                .document(classID)
                .collection("fb_date_path".localize)
                .document(date)
                .getDocument { documentSnapshot, err in
                    if let err = err {
                        ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: err.localizedDescription, type: .registrationManagerError)
                    } else {
                        do {
                            if let registrationInfoDocument = documentSnapshot{
                                if let registrationInfoData = try registrationInfoDocument.data(as: RegistrationInfo.self) {
                                    self.registrationInfo = registrationInfoData
                                }
                            }
                        } catch {
                            ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .registrationManagerError)
                        }
                    }
                }
            
            db
                .collection("fb_schools_path".localize)
                .document(selectedSchool)
                .collection("fb_classes_path".localize)
                .document(classID)
                .collection("fb_date_path".localize)
                .document(date)
                .collection(selectedIsMorning ? "fb_morningRegistration_path".localize : "fb_afternoonRegistration_path".localize)
                .getDocuments() {  (querySnapshot, err) in
                    if let err = err {
                        ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: err.localizedDescription, type: .registrationManagerError)
                    } else {
                        for document in querySnapshot!.documents {
                            do {
                                if let registration = try document.data(as: Registration.self) {
                                    self.registrations.append(registration)
                                    self.registrations.sort { $0.studentName < $1.studentName }
                                }
                            }
                            catch {
                                ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .registrationManagerError)
                            }
                        }
                    }
                }
        }
    }
    
    /**
     Retrieves all the students' data from a given class
     
     - parameter className:      The unique name specifier of the class.
     - parameter date:           A date string in the format: dd-MM-yyyy.
     - parameter isMorning:      A boolean value that determines if the registration should be put in the morning or afternoon table.
     - parameter completion:     A Callback that returns if the write to the database went through.
     */
    func saveRegistrations(classID: String, date: String, isMorning: Bool, completion: @escaping (Bool) -> ()) {
        if !registrations.isEmpty {
            // Create new write batch that will pushed at the same time.
            let batch = db.batch()
            
            for (var registration) in registrations {
                if registration.reason != .notRegistered {
                    // Absence registration for the class collection
                    let registrationRef = db
                        .collection("fb_schools_path".localize)
                        .document(selectedSchool)
                        .collection("fb_classes_path".localize)
                        .document(classID)
                        .collection("fb_date_path".localize)
                        .document(date)
                        .collection(isMorning ? "fb_morningRegistration_path".localize : "fb_afternoonRegistration_path".localize)
                        .document(registration.studentID)
                    
                    batch.updateData(["reason" : registration.reason.rawValue, "isAbsenceRegistered": true], forDocument: registrationRef)
                    
                    // Absence for the student collection
                    if registration.isAbsenceRegistered {
                        let absenceStudentRef = db
                            .collection("fb_students_path".localize)
                            .document(registration.studentID)
                            .collection("fb_absence_path".localize)
                            .whereField("date", isEqualTo: date)
                            .whereField("isMorning", isEqualTo: isMorning)
                        
                        absenceStudentRef.getDocuments { querySnapshot, err in
                            if err != nil {
                                completion(false)
                            } else {
                                for document in querySnapshot!.documents {
                                    document.reference.updateData(["reason" : registration.reason.rawValue])
                                }
                            }
                        }
                    } else {
                        let absenceStudentRef = db
                            .collection("fb_students_path".localize)
                            .document(registration.studentID)
                            .collection("fb_absence_path".localize)
                            .document()
                        
                        if let index = self.registrations.firstIndex(where: {$0.studentID == registration.studentID}) {
                            self.registrations[index].isAbsenceRegistered = true
                            registration.isAbsenceRegistered = true
                        }
                        
                        do {
                            try batch.setData(from: registration, forDocument: absenceStudentRef)
                        } catch {
                            completion(false)
                        }
                    }
                    
                } else if registration.reason == .notRegistered && registration.isAbsenceRegistered {
                    let registrationRef = db
                        .collection("fb_schools_path".localize)
                        .document(selectedSchool)
                        .collection("fb_classes_path".localize)
                        .document(classID)
                        .collection("fb_date_path".localize)
                        .document(date)
                        .collection(isMorning ? "fb_morningRegistration_path".localize : "fb_afternoonRegistration_path".localize)
                        .document(registration.studentID)
                    
                    let absenceStudentRef = db
                        .collection("fb_students_path".localize)
                        .document(registration.studentID)
                        .collection("fb_absence_path".localize)
                        .whereField("date", isEqualTo: date)
                        .whereField("isMorning", isEqualTo: isMorning)
                    
                    absenceStudentRef.getDocuments { querySnapshot, err in
                        if err != nil {
                            completion(false)
                        } else {
                            for document in querySnapshot!.documents {
                                document.reference.delete()
                            }
                        }
                    }
                    
                    batch.updateData(["reason" : registration.reason.rawValue, "isAbsenceRegistered" : false], forDocument: registrationRef)
                }
            }
            
            let registrationInfoRef = db
                .collection("fb_schools_path".localize)
                .document(selectedSchool)
                .collection("fb_classes_path".localize)
                .document(classID)
                .collection("fb_date_path".localize)
                .document(date)
            
            if isMorning && !registrationInfo.hasMorningBeenRegistrered && date == Date().selectedDateFormatted {
                do {
                    registrationInfo.hasMorningBeenRegistrered = true
                    try batch.setData(from: registrationInfo, forDocument: registrationInfoRef)
                } catch {
                    completion(false)
                }
            } else if !isMorning && !registrationInfo.hasAfternoonBeenRegistrered && date == Date().selectedDateFormatted {
                do {
                    registrationInfo.hasAfternoonBeenRegistrered = true
                    try batch.setData(from: registrationInfo, forDocument: registrationInfoRef)
                } catch {
                    completion(false)
                }
            }
            
            // Writing our big batch of data to firebase
            batch.commit() { err in
                if err != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    /**
     Retrieves all the students' data from a given class
     
     - parameter className:      The unique name specifier of the class
     */
    func fetchStudents(className: String) {
            students.removeAll()
            selectedClass = className
            
            db
                .collection("fb_schools_path".localize)
                .document(selectedSchool)
                .collection("fb_classes_path".localize)
                .document(className)
                .collection("fb_students_path".localize)
                .getDocuments { querySnapshot, err in
                    if let err = err {
                        ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: err.localizedDescription, type: .registrationManagerInitError)
                    } else {
                        for document in querySnapshot!.documents {
                            let studentID = document.documentID
                            self.db.collection("fb_students_path".localize)
                                .document(studentID)
                                .getDocument { studentDoc, error in
                                    if let data = studentDoc {
                                        do {
                                            if let student = try data.data(as: Student.self) {
                                                self.students.append(student)
                                                self.students.sort { $0.name < $1.name }
                                            }
                                        }
                                        catch {
                                            ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .registrationManagerInitError)
                                        }
                                    }
                                }
                        }
                    }
                }
    }
}
