//
//  RegistrationManager.swift
//  Registr
//
//  Created by Simon Andersen on 10/03/2022.
//

import Foundation
import FirebaseFirestore

class RegistrationManager: ObservableObject {
    
    @Published var registrations = [Registration]()
    @Published var students = [Student]()
    @Published var classes = [String]()
    let db = Firestore.firestore()
    
    //TODO: --- We need to implement recieving class string in the method from the view - We can make the date logic from this manager class ---
    func fetchRegistrations(className: String) {
        /// Line 21 will be used later on in the project
        //let currentDate = getFormattedCurrentDate()
        db
            .collection("fb_classes_path".localize)
            .document(className)
            .collection("fb_date_path".localize)
            .document("12-03-2022")
            .collection("fb_registrations_path".localize)
            .getDocuments() {  (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            if let registration = try document.data(as: Registration.self) {
                                self.registrations.append(registration)
                                self.registrations.sort {
                                    $0.studentName < $1.studentName
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
    
    func setAbsenceReason(absenceReason: String, index: Int) {
        registrations[index].reason = absenceReason
    }
    
    // Retrieves every class name
    func fetchClasses() {
        db
            .collection("fb_classes_path".localize)
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.classes.append(document.documentID)
                    }
                }
            }
    }
    
    // Retrieves all the students' data from a given class
    func fetchStudents(className: String) {
        db
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
                                            self.students.sort {
                                                $0.name < $1.name
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
    
    func saveRegistrations(className: String) {
        if !registrations.isEmpty {
            // Get new write batch
            let batch = db.batch()
            
            //let currentDate = getFormattedCurrentDate()
            
            for (var registration) in registrations {
                if !registration.reason.isEmpty {
                    let registrationRef = db
                        .collection("fb_classes_path".localize)
                        .document("0.x")
                        .collection("fb_date_path".localize)
                        .document("12-03-2022")
                        .collection("fb_registrations_path".localize)
                        .document(registration.studentID)
                    
                    let registrationStudentRef = db
                        .collection("fb_students_path".localize)
                        .document(registration.studentID)
                        .collection("fb_absense_path".localize)
                        .document("12-03-2022")
                    
                    registration.isAbsenceRegistered = true
                    do {
                        batch.updateData(["reason" : registration.reason, "isAbsenceRegistered": true], forDocument: registrationRef)
                        try batch.setData(from: registration, forDocument: registrationStudentRef)
                    } catch {
                        print("Decoding failed")
                    }
                } else if registration.isAbsenceRegistered && registration.reason.isEmpty {
                    let registrationRef = db
                        .collection("fb_classes_path".localize)
                        .document("0.x")
                        .collection("fb_date_path".localize)
                        .document("12-03-2022")
                        .collection("fb_registrations_path".localize)
                        .document(registration.studentID)
                    
                    let registrationStudentRef = db
                        .collection("fb_students_path".localize)
                        .document(registration.studentID)
                        .collection("fb_absense_path".localize)
                        .document("12-03-2022")
                    
                    batch.updateData(["reason" : registration.reason, "isAbsenceRegistered" : false], forDocument: registrationRef)
                    batch.deleteDocument(registrationStudentRef)
                }
            }
            
            // Writing our big batch of data to firebase
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Batch write succeeded.")
                }
            }
        }
    }
    
    // Retrieving the current date
    func getFormattedCurrentDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentDateFormatted = dateFormatter.string(from: currentDate)
        
        return currentDateFormatted
    }
}
