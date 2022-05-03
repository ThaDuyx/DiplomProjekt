//
//  RegistrationManager.swift
//  Registr
//
//  Created by Simon Andersen on 10/03/2022.
//

import Foundation
import FirebaseFirestore

class RegistrationManager: ObservableObject {
    
    // Collections
    @Published var registrationInfo = RegistrationInfo()
    @Published var registrations = [Registration]()
    @Published var students = [Student]()
    @Published var classes = [ClassInfo]()
    @Published var studentRegistrationList = [Registration]()
    
    // Firestore db reference
    private let db = Firestore.firestore()
    
    // Selectors
    private var selectedClass = String()
    private var selectedDate = String()
    private var selectedStudent = String()
    private var selectedIsMorning: Bool = true
    private var selectedSchool: String {
        if let schoolID = UserManager.shared.user?.associatedSchool {
            return schoolID
        } else {
            return ""
        }
    }
    
    init() {
        fetchClasses()
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
    func fetchRegistrations(className: String, date: String, isMorning: Bool) {
        // If 'selectedClass' is the same as the className input we have already fetched the registration.
        // In this case will not have to fetch it again.
        if selectedClass != className || selectedDate != date || selectedIsMorning != isMorning {
            registrations.removeAll()
            registrationInfo = RegistrationInfo()
            selectedClass = className
            selectedDate = date
            selectedIsMorning = isMorning
            
            db
                .collection("fb_schools_path".localize)
                .document(selectedSchool)
                .collection("fb_classes_path".localize)
                .document(className)
                .collection("fb_date_path".localize)
                .document(date)
                .getDocument { documentSnapshot, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        do {
                            if let registrationInfoDocument = documentSnapshot{
                                if let registrationInfoData = try registrationInfoDocument.data(as: RegistrationInfo.self) {
                                    self.registrationInfo = registrationInfoData
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            
            db
                .collection("fb_schools_path".localize)
                .document(selectedSchool)
                .collection("fb_classes_path".localize)
                .document(className)
                .collection("fb_date_path".localize)
                .document(date)
                .collection(selectedIsMorning ? "fb_morningRegistration_path".localize : "fb_afternoonRegistration_path".localize)
                .getDocuments() {  (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            do {
                                if let registration = try document.data(as: Registration.self) {
                                    self.registrations.append(registration)
                                    self.registrations.sort { $0.studentName < $1.studentName }
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
    
    /**
     Retrieves all the students' data from a given class
     
     - parameter className:      The unique name specifier of the class.
     - parameter date:           A date string in the format: dd-MM-yyyy.
     - parameter isMorning:      A boolean value that determines if the registration should be put in the morning or afternoon table.
     - parameter completion:     A Callback that returns if the write to the database went through.
     */
    func saveRegistrations(className: String, date: String, isMorning: Bool, completion: @escaping (Bool) -> ()) {
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
                        .document(className)
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
                            .collection("fb_absense_path".localize)
                            .whereField("date", isEqualTo: date)
                            .whereField("isMorning", isEqualTo: isMorning)
                        
                        absenceStudentRef.getDocuments { querySnapshot, err in
                            if let err = err {
                                print("Error getting documents: \(err)")
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
                            .collection("fb_absense_path".localize)
                            .document()
                        
                        if let index = self.registrations.firstIndex(where: {$0.studentID == registration.studentID}) {
                            self.registrations[index].isAbsenceRegistered = true
                            registration.isAbsenceRegistered = true
                        }
                        
                        do {
                            try batch.setData(from: registration, forDocument: absenceStudentRef)
                        } catch {
                            print("Decoding failed")
                        }
                    }
                    
                } else if registration.reason == .notRegistered && registration.isAbsenceRegistered {
                    let registrationRef = db
                        .collection("fb_schools_path".localize)
                        .document(selectedSchool)
                        .collection("fb_classes_path".localize)
                        .document(className)
                        .collection("fb_date_path".localize)
                        .document(date)
                        .collection(isMorning ? "fb_morningRegistration_path".localize : "fb_afternoonRegistration_path".localize)
                        .document(registration.studentID)
                    
                    let absenceStudentRef = db
                        .collection("fb_students_path".localize)
                        .document(registration.studentID)
                        .collection("fb_absense_path".localize)
                        .whereField("date", isEqualTo: date)
                        .whereField("isMorning", isEqualTo: isMorning)
                    
                    absenceStudentRef.getDocuments { querySnapshot, err in
                        if let err = err {
                            print("Error getting documents: \(err)")
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
                .document(className)
                .collection("fb_date_path".localize)
                .document(date)
            
            if isMorning && !registrationInfo.hasMorningBeenRegistrered && date == Date().selectedDateFormatted {
                do {
                    registrationInfo.hasMorningBeenRegistrered = true
                    try batch.setData(from: registrationInfo, forDocument: registrationInfoRef)
                } catch {
                    print("Error encoding document \(error)")
                }
            } else if !isMorning && !registrationInfo.hasAfternoonBeenRegistrered && date == Date().selectedDateFormatted {
                do {
                    registrationInfo.hasAfternoonBeenRegistrered = true
                    try batch.setData(from: registrationInfo, forDocument: registrationInfoRef)
                } catch {
                    print("Error encoding document \(error)")
                }
            }
            
            // Writing our big batch of data to firebase
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
    
    // Retrieves every class name
    func fetchClasses() {
        db
            .collection("fb_schools_path".localize)
            .document(selectedSchool)
            .collection("fb_classes_path".localize)
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            if let classSnapshot = try document.data(as: ClassInfo.self) {
                                self.classes.append(classSnapshot)
                            }
                        }
                        catch {
                            print(error)
                        }
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
                        print("Error getting documents: \(err)")
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
                                            print(error)
                                        }
                                    }
                                }
                        }
                    }
                }
    }
    
    func fetchStudentAbsence(studentID: String) {
        if selectedStudent != studentID {
            studentRegistrationList.removeAll()
            
            db
                .collection("fb_students_path".localize)
                .document(studentID)
                .collection("fb_absense_path".localize)
                .getDocuments { querySnapshot, err in
                    if let err = err {
                        // TODO: Error Handling
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            do {
                                if let registration = try document.data(as: Registration.self) {
                                    self.studentRegistrationList.append(registration)
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
