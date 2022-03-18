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
    func fetchRegistrations() {
        /// Line 21 will be used later on in the project
        //let currentDate = getFormattedCurrentDate()
        db
            .collection("classes")
            .document("0.x")
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
                            }
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
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
                        self.db.collection("fb_students_path".localize).document(studentID).getDocument { studentDoc, error in
                            if let data = studentDoc {
                                do {
                                    if let student = try data.data(as: Student.self) {
                                        self.students.append(student)
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
            for student in students {
                if let id = student.id {
                    do {
                        let classRegistrationForCurrentDateRef = db
                            .collection("fb_classes_path")
                            .document("0.x")
                            .collection("fb_date_path".localize)
                            .document("12-03-2022")
                            .collection("fb_registrations_path")
                            .document(id)
                        
                        let studentRegistrationForCurrentDateRef = db
                            .collection("fb_students_path".localize)
                            .document(id)
                            .collection("fb_absense_path")
                            .document()
                        try batch.setData(from: registrations.first(where: {$0.id == id}), forDocument: classRegistrationForCurrentDateRef)
                        try batch.setData(from: registrations.first(where: {$0.id == id}), forDocument: studentRegistrationForCurrentDateRef)
                    }
                    catch {
                        print("Could not encode registration")
                    }
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
