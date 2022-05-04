//
//  StudentListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 25/03/2022.
//

import SwiftUI
import SwiftUIKit

struct StudentListView: View {
    @EnvironmentObject var registrationManager: RegistrationManager
    @StateObject var errorHandling = ErrorHandling()
    @StateObject private var context = FullScreenCoverContext()

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
        .fullScreenCover(item: $errorHandling.appError) { appError in
            ErrorView(title: appError.title, error: appError.description) {
                if appError.type == .registrationManagerInitError {
                    registrationManager.fetchClasses()
                } else {
                    registrationManager.fetchStudents(className: selectedClass)
                }
            }
        }
    }
}

struct StudentListView_Previews: PreviewProvider {
    static var previews: some View {
        StudentListView(selectedClass: "0.x")
    }
}
