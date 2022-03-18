//
//  StudentClassListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 16/03/2022.
//

import SwiftUI

// This is for testing
struct Student: Identifiable {
    var id = UUID()
    var name: String
    var absenceState: String
}

struct StudentClassListView: View {
    @State private var studentState: String = ""
    @State private var listIndex = UUID()
    @State private var showSheet: Bool = false
    
    @State var students = [
        Student(name: "Simon Andersen", absenceState: ""),
        Student(name: "Alice Andersen", absenceState: ""),
        Student(name: "Bob Andersen", absenceState: ""),
        Student(name: "Charlie Andersen", absenceState: ""),
        Student(name: "Christoffer Andersen", absenceState: ""),
        Student(name: "Søren Andersen", absenceState: ""),
        Student(name: "Peter Andersen", absenceState: ""),
        Student(name: "Simone Andersen", absenceState: ""),
        Student(name: "Sarah Andersen", absenceState: "")
    ]
    
    var body: some View {
        ZStack{
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            Form {
                Section {
                    ForEach(0..<students.count) { index in
                       let _ = print("The first time: \(students)")
                        StudentSection(index: "\(index+1)", name: students[index].name, absenceState: absenceStringState(studentID: students[index].id, studentAbsenceState: students[index].absenceState))
                            .onTapGesture {
                                studentState = students[index].absenceState
                                listIndex = students[index].id
                                showSheet.toggle()
                                print("The second time: \(students)")
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
                            print("The studentState is now: \(studentState)")
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
                print("on dismiss")
            }
        }
    }
}

private extension StudentClassListView {
    func absenceStringState(studentID: UUID, studentAbsenceState: String) -> String {
        
        var absenceState = ""

        if studentID == listIndex {
            absenceState = studentState
        } else if !studentAbsenceState.isEmpty {
            return studentAbsenceState
        }
        
        return absenceState
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
