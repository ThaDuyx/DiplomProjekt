//
//  StudentListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 25/03/2022.
//

import SwiftUI

struct StudentListView: View {
    @EnvironmentObject var registrationViewModel: RegistrationViewModel
    @EnvironmentObject var classViewModel: ClassViewModel
    @StateObject var errorHandling = ErrorHandling()

    var selectedClass: ClassInfo
    
    init(selectedClass: ClassInfo) {
        self.selectedClass = selectedClass
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(registrationViewModel.students, id: \.self) { student in
                    StudentSection(studentName: student.name, studentID: student.id ?? "", student: student)
                }
                .listRowBackground(Color.frolyRed)
                .listRowSeparatorTint(Color.white)
            }
        }
        .navigationTitle("sl_navigationtitle".localize + selectedClass.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            registrationViewModel.fetchStudents(classID: selectedClass.classID)
        }
        .fullScreenCover(item: $errorHandling.appError) { appError in
            ErrorView(title: appError.title, error: appError.description) {
                if appError.type == .registrationManagerInitError {
                    classViewModel.fetchClasses()
                } else {
                    registrationViewModel.fetchStudents(classID: selectedClass.classID)
                }
            }
        }
    }
}

struct StudentListView_Previews: PreviewProvider {
    static var previews: some View {
        StudentListView(selectedClass: ClassInfo(isDoubleRegistrationActivated: false, name: "0.x", classID: "qq11ww22ee33"))
    }
}
