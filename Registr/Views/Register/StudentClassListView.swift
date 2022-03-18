//
//  StudentClassListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 16/03/2022.
//

import SwiftUI

struct StudentClassListView: View {
    @State var studentState: String = ""
    @State var selectedStudent: Student = Student(id: "", name: "", absenceState: "")
    @State var showSheet: Bool = false
    
    @ObservedObject var students: Students = Students()
    
    var body: some View {
        ZStack{
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            Form {
                Section {
                    ForEach(0..<students.students.count) { index in
                        let _ = print("\(students.students[index].id) this is a list of students: \(students.students[index].absenceState)")
                        StudentSection(
                            index: "\(index+1)",
                            name: students.students[index].name,
                            absenceState: students.students[index].absenceState
                        )
                            .onTapGesture {
                                if !studentState.isEmpty {
                                    studentState = ""
                                }
                                selectedStudent = students.students[index]
                                showSheet.toggle()
                            }
                    }
                }
                .listRowBackground(Color.clear)
            }
            .halfSheet(showSheet: $showSheet) {
                ZStack {
                    Resources.BackgroundGradient.backgroundGradient
                        .ignoresSafeArea()
                    HStack {
                        Button {
                            studentState = "F"
                            students.absenceStringState(studentID: selectedStudent.id, student: selectedStudent, studentState: studentState)
                            showSheet.toggle()
                        } label: {
                            Text("For sent")
                        }
                        Button {
                            studentState = "U"
                            students.absenceStringState(studentID: selectedStudent.id, student: selectedStudent, studentState: studentState)
                            showSheet.toggle()
                        } label: {
                            Text("Ulovligt")
                        }
                        Button {
                            studentState = "S"
                            students.absenceStringState(studentID: selectedStudent.id, student: selectedStudent, studentState: studentState)
                            showSheet.toggle()
                        } label: {
                            Text("Syg")
                        }
                    }
                }
                .ignoresSafeArea()
            } onEnd: {
                showSheet.toggle()
            }
        }
    }
}

struct StudentSection: View {
    var index: String
    var name: String
    var absenceState: String
    
    init(index: String, name: String, absenceState: String) {
        // To make the background transparent, so the gradient background can be used.
        UITableView.appearance().backgroundColor = .clear
        self.index = index
        self.name = name
        self.absenceState = absenceState
    }
    
    var body: some View {
        HStack {
            HStack {
                Text(index)
                    .subTitleTextStyle()
            }
            Spacer()
            HStack {
                Text(name)
                    .subTitleTextStyle()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 1)
            )
            Spacer()
            HStack {
                Button {} label: {
                    Text(absenceState)
                        .lightSubTitleTextStyle()
                }
                .frame(width: 40, height: 30)
                .background(Resources.Color.Colors.darkBlue)
            }
        }
        .padding(4)
    }
}


struct StudentClassListView_Previews: PreviewProvider {
    static var previews: some View {
        StudentClassListView()
    }
}
