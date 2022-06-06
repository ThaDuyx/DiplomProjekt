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
    @Published var dateArray: [String] = [
        "06-06-2022",
        "07-06-2022",
        "08-06-2022",
        "09-06-2022",
        "10-06-2022"
    ]
    @Published var students = [Student]()
    @Published var classInfo = ClassInfo(isDoubleRegistrationActivated: false, name: "", classID: "")
    
    private var testStudent: Student = Student(id: "1234", name: "Alice Testable", className: "1.a", email: "student@school.com", classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: "1.a", classID: "abcdefg1234"), associatedSchool: "abcdefg1234", cpr: "123456-7890")
    private var classes = [ClassInfo]()
    private let db = Firestore.firestore()
    
    // School & Class selectors, change these variable to choose the specific school or class.
    // Gladsaxe Skole
    let selectedSchool = "EXvXPS4HuVnxu7LhZRPt"
    // 9.x
    let selectedClass = "KkT176TAZiImYfurOJuk"
    
    init() {
        // fetchTestStudents()
        fetchClass(classID: selectedClass)
        fetchStudents(classID: selectedClass)
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
                let nextDay = futureDate.formatSpecificDate(date: futureDate)
                print(futureDate)
                dateArray.append(nextDay)
            }
            print(dateArray)
        }
    }
    
    /// This method is used to fill the 'students' array with student that can be used to create new absence registrations.
    func fetchStudents(classID: String) {
        db
            .collection("fb_schools_path".localize)
            .document(selectedSchool)
            .collection("fb_classes_path".localize)
            .document(classID)
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
    
    func fetchClass(classID: String) {
        db
            .collection("fb_schools_path".localize)
            .document(selectedSchool)
            .collection("fb_classes_path".localize)
            .document(classID)
            .getDocument { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    do {
                        if let classSnapshot = try querySnapshot!.data(as: ClassInfo.self) {
                            self.classInfo = classSnapshot
                        }
                    }
                    catch {
                        print(error)
                    }
                }
            }
        
        
//            .getDocuments { querySnapshot, err in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        do {
//                            if let classSnapshot = try document.data(as: ClassInfo.self) {
//                                self.classes.append(classSnapshot)
//                            }
//                        }
//                        catch {
//                            print(error)
//                        }
//                    }
//                }
//            }
    }
    
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
    
    /// This method will take the global date array from this class and create registrations from a class.
    /// Though the method 'fetchStudents' will have to be called first for this to be used.
    func createRegistrationDates() {
        for date in dateArray {
            let newRegistration = db
                .collection("fb_schools_path".localize)
                .document(selectedSchool)
                .collection("fb_classes_path".localize)
                .document(selectedClass)
                .collection("fb_date_path".localize)
                .document(date)
            
            do {
                let registrationinfo = RegistrationInfo()
                try newRegistration.setData(from: registrationinfo)
            } catch {
                print("Error in encoding data \(error)")
            }
            
            for student in students {
                if let id = student.id {
                    newRegistration
                        .collection("fb_morningRegistration_path".localize)
                        .document(id)
                        .setData(["className" : selectedClass,
                                  "date" : date,
                                  "isAbsenceRegistered" : false,
                                  "isMorning" : true,
                                  "reason" : "",
                                  "studentID" : id,
                                  "studentName" : student.name,
                                  "validated" : false])
                    
                    if classInfo.isDoubleRegistrationActivated {
                        newRegistration
                            .collection("fb_afternoonRegistration_path".localize)
                            .document(id)
                            .setData(["className" : selectedClass,
                                      "date" : date,
                                      "isAbsenceRegistered" : false,
                                      "isMorning" : false,
                                      "reason" : "",
                                      "studentID" : id,
                                      "studentName" : student.name,
                                      "validated" : false])
                    }
                }
            }
        }
    }
    
    func fetchTestStudents() {
        db
            .collection("test")
            .document("testableData")
            .collection("students")
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            if let student = try document.data(as: Student.self) {
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
