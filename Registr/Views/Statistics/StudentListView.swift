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
                ForEach(0..<registrationManager.students.count, id: \.self) { student in
                    StudentEntity(studentName: registrationManager.students[student].name, studentID: registrationManager.students[student].id ?? "")
                }
                .listRowBackground(Resources.Color.Colors.frolyRed)
                .listRowSeparatorTint(Resources.Color.Colors.white)
            }
        }
        .navigationTitle("Elever i \(selectedClass)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            registrationManager.fetchStudents(className: selectedClass)
        }
    }
}

struct StudentEntity: View {
    let studentName: String
    let studentID: String
    
    var body: some View {
        HStack {
            Text(studentName)
                .boldBodyTextStyle()
                .frame(maxWidth: .infinity, alignment: .center)
            
            NavigationLink(destination: StudentView(studentName: studentName, isParent: false, studentID: studentID)) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)

            Image(systemName: "chevron.right")
                .foregroundColor(Resources.Color.Colors.white)
                .padding(.trailing, 10)
        }
        .frame(height: 35)
    }
}

struct StudentListView_Previews: PreviewProvider {
    static var previews: some View {
        StudentListView(selectedClass: "0.x")
    }
}
