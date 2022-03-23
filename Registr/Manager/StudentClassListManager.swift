//
//  StudentClassListManager.swift
//  Registr
//
//  Created by Christoffer Detlef on 18/03/2022.
//

import SwiftUI

// This is for testing - CAD
struct StudentTest {
    let id: Int
    var name: String
    var absenceState: String
}

class Students: ObservableObject {
    @Published var students: [StudentTest] = [
        StudentTest(id: 1, name: "Simon Andersen", absenceState: ""),
        StudentTest(id: 2, name: "Alice Andersen", absenceState: ""),
        StudentTest(id: 3, name: "Bob Andersen", absenceState: ""),
        StudentTest(id: 4, name: "Charlie Andersen", absenceState: ""),
        StudentTest(id: 5, name: "Christoffer Andersen", absenceState: ""),
        StudentTest(id: 6, name: "Søren Andersen", absenceState: ""),
        StudentTest(id: 7, name: "Peter Andersen", absenceState: ""),
        StudentTest(id: 8, name: "Simone Andersen", absenceState: ""),
        StudentTest(id: 9, name: "Sarah Andersen", absenceState: "")
    ]
    
    func absenceStringState(studentState: String, index: Int) {
        students[index].absenceState = studentState
    }
}
