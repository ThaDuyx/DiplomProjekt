//
//  StudentClassListManager.swift
//  Registr
//
//  Created by Christoffer Detlef on 18/03/2022.
//

import SwiftUI

// This is for testing
struct Student {
    let id: Int
    var name: String
    var absenceState: String
}

class Students: ObservableObject {
    @Published var students: [Student] = [
        Student(id: 1, name: "Simon Andersen", absenceState: ""),
        Student(id: 2, name: "Alice Andersen", absenceState: ""),
        Student(id: 3, name: "Bob Andersen", absenceState: ""),
        Student(id: 4, name: "Charlie Andersen", absenceState: ""),
        Student(id: 5, name: "Christoffer Andersen", absenceState: ""),
        Student(id: 6, name: "Søren Andersen", absenceState: ""),
        Student(id: 7, name: "Peter Andersen", absenceState: ""),
        Student(id: 8, name: "Simone Andersen", absenceState: ""),
        Student(id: 9, name: "Sarah Andersen", absenceState: "")
    ]
    
    func absenceStringState(studentID: Int, student: Student, studentState: String, index: Int) {
        var string = ""
        if studentID == student.id {
            string = studentState
            students[index].absenceState = string
        }
    }
}
