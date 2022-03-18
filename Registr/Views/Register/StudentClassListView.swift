//
//  StudentClassListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 16/03/2022.
//

import SwiftUI

// This is for testing
struct Student: Identifiable {
    var id: Int
    var name: String
    @State var absenceState: String
}

struct StudentClassListView: View {
    @State var studentState: String = ""
    @State var listIndex: Int = 0
    @State var showSheet: Bool = false
    
    @State var students = [
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
    
    var body: some View {
        ZStack{
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            Form {
                Section {
                    ForEach(0..<students.count) { index in
                        StudentSection(index: "\(index+1)", name: students[index].name, absenceState: absenceStringState(studentID: listIndex, student: students[index]))
                            .onTapGesture {
                                students[index].absenceState = studentState
                                listIndex = students[index].id
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
                            showSheet.toggle()
                        } label: {
                            Text("For sent")
                        }
                        Button {
                            studentState = "U"
                            showSheet.toggle()
                        } label: {
                            Text("Ulovligt")
                        }
                        Button {
                            studentState = "S"
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

private extension StudentClassListView {
    func absenceStringState(studentID: Int, student: Student) -> String {
        
        var string = ""
        if studentID == student.id {
            string = studentState
            student.absenceState = string
        }
        return string
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
