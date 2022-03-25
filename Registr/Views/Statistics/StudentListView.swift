//
//  StudentListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 25/03/2022.
//

import SwiftUI

struct StudentListView: View {
    @ObservedObject var registrationManager = RegistrationManager()
    @ObservedObject var students = Students()
    var selectedClass: String
    
    init(selectedClass: String) {
        self.selectedClass = selectedClass
        self.registrationManager.fetchStudents(className: selectedClass)
    }
    
    var body: some View {
        ZStack {
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            Form {
                Section {
                    ForEach(0..<registrationManager.students.count, id: \.self) { student in
                        StudentEntity(studentName: registrationManager.students[student].name)
                    }
                }
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Elever i \(selectedClass)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StudentEntity: View {
    let studentName: String
    
    var body: some View {
        NavigationLink(destination: StatisticsView(className: studentName, isStudentPresented: true)) {
            HStack {
                Text(studentName)
                    .darkBodyTextStyle()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
        }
        .padding(.trailing, 20)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 1)
        )
        .padding(4)
    }
}

struct StudentListView_Previews: PreviewProvider {
    static var previews: some View {
        StudentListView(selectedClass: "0.x")
    }
}
