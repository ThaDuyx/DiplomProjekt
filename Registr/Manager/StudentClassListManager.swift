//
//  StudentClassListManager.swift
//  Registr
//
//  Created by Christoffer Detlef on 18/03/2022.
//

import SwiftUI

// This is for testing
class Student: ObservableObject, Identifiable {
    var id: String = ""
    var name: String = ""
    @Published var absenceState: String = ""
    
    init(id: String, name: String, absenceState: String) {
        self.id = id
        self.name = name
        self.absenceState = absenceState
    }
}

class Students: ObservableObject {
    @Published var students = [
        Student(id: "1", name: "Simon Andersen", absenceState: ""),
        Student(id: "2", name: "Alice Andersen", absenceState: ""),
        Student(id: "3", name: "Bob Andersen", absenceState: ""),
        Student(id: "4", name: "Charlie Andersen", absenceState: ""),
        Student(id: "5", name: "Christoffer Andersen", absenceState: ""),
        Student(id: "6", name: "Søren Andersen", absenceState: ""),
        Student(id: "7", name: "Peter Andersen", absenceState: ""),
        Student(id: "8", name: "Simone Andersen", absenceState: ""),
        Student(id: "9", name: "Sarah Andersen", absenceState: "")
    ]
    
    func absenceStringState(studentID: String, student: Student, studentState: String) {
        var string = ""
        print("1 For \(student.id) this is: \(student.absenceState)")
        if studentID == student.id {
            string = studentState
            student.absenceState = string
            print("2 For \(student.id) this is: \(student.absenceState)")
        }
    }
}
