//
//  FeedDatabaseManager.swift
//  Registr
//
//  Created by Simon Andersen on 03/04/2022.
//

import Foundation
import FirebaseFirestore
/*
 This class is used to feed the database
 */
class FeedDatabaseManager: ObservableObject {
    @Published var dateArray: [String] = ["20-04-2022"]
    @Published var students: [Student] = []
    
    init() {
        fetchStudents(className: "0.x")
    }
    
    /// This method fills our date array with date strings in the format 'dd-MM-yyyy'.
    func createDateArray() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        // ---------------------
        /// Change this variable to set the number of days to to create in the dateArray
        let component = DateComponents(month: 1)
        // ---------------------
        
        let endDate = calendar.date(byAdding: component, to: currentDate)
        let componentTwo = DateComponents(day: 1)
        var futureDate = Date()
        
        if let endDate = endDate {
            print(endDate)
            while futureDate < endDate {
                futureDate = calendar.date(byAdding: componentTwo, to: futureDate)!
                let nextDay = futureDate.formatSpecificData(date: futureDate)
                print(futureDate)
                dateArray.append(nextDay)
            }
            print(dateArray)
        }
    }
    
    /// This method is used to fill the 'students' array with student that can be used to create new absence registrations.
    func fetchStudents(className: String) {
        let db = Firestore.firestore()
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
                        db.collection("fb_students_path".localize)
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
    
    /// This method will take the global date array from this class and create registrations from a class.
    /// Though the method 'fetchStudents' will have to be called first for this to be used.
    func createRegistrationDates(className: String) {
        let db = Firestore.firestore()
        
        for date in dateArray {
//            let newRegistration = db
//                .collection("fb_classes_path".localize)
//                .document(className)
//                .collection("fb_date_path".localize)
//                .document(date)
//            newRegistration.setData(["exsists" : true])
            
            let afternoonRegistration = db
                .collection("fb_classes_path".localize)
                .document(className)
                .collection("fb_date_path".localize)
                .document(date)
                
            afternoonRegistration.setData(["exsists" : true])
                
//            for student in students {
//                if let id = student.id {
//                    newRegistration.collection("fb_registrations_path".localize)
//                        .document(id)
//                        .setData(["className" : className,
//                                  "date" : date,
//                                  "isAbsenceRegistered" : false,
//                                  "reason" : "", "studentID" : id,
//                                  "studentName" : student.name,
//                                  "validated" : false])
//                }
//            }
            
            for student in students {
                if let id = student.id {
                    afternoonRegistration.collection("fb_afternoonRegistration_path".localize)
                        .document(id)
                        .setData(["className" : className,
                                  "date" : date,
                                  "isAbsenceRegistered" : false,
                                  "reason" : "", "studentID" : id,
                                  "studentName" : student.name,
                                  "validated" : false])
                }
            }
        }
    }
}
