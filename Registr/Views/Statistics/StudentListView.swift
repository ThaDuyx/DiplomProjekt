//
//  StudentListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 25/03/2022.
//

import SwiftUI

struct StudentListView: View {
    @EnvironmentObject var registrationManager: RegistrationManager
    
    var selectedClass: String
    
    init(selectedClass: String) {
        self.selectedClass = selectedClass
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(registrationManager.students, id: \.self) { student in
                    StudentSection(studentName: student.name, studentID: student.id ?? "", student: student)
                }
                .listRowBackground(Color.frolyRed)
                .listRowSeparatorTint(Color.white)
            }
        }
        .navigationTitle("Elever i \(selectedClass)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            registrationManager.fetchStudents(className: selectedClass)
        }
    }
}

struct StudentListView_Previews: PreviewProvider {
    static var previews: some View {
        StudentListView(selectedClass: "0.x")
    }
}
