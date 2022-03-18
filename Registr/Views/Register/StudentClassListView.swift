//
//  StudentClassListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 16/03/2022.
//

import SwiftUI

struct StudentClassListView: View {
    @State var showSheet: Bool = false
    @State var studentAbsenceState: String = ""
    @State var studentIndex: Int = 0
    
    @ObservedObject var students = Students()
    
    var body: some View {
        ZStack{
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            Form {
                Section {
                    ForEach(0..<students.students.count, id: \.self) { index in
                        StudentSection(
                            index: "\(index+1)",
                            name: students.students[index].name,
                            absenceState: students.students[index].absenceState
                        )
                            .onTapGesture {
                                if !studentAbsenceState.isEmpty {
                                    studentAbsenceState = ""
                                }
                                studentIndex = index
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
                            studentAbsenceState = "F"
                            students.absenceStringState(studentState: studentAbsenceState, index: studentIndex)
                            showSheet.toggle()
                        } label: {
                            Text("For sent")
                        }
                        .buttonStyle(Resources.CustomButtonStyle.ActionButtonStyle())

                        Button {
                            studentAbsenceState = "U"
                            students.absenceStringState(studentState: studentAbsenceState, index: studentIndex)
                            showSheet.toggle()
                        } label: {
                            Text("Ulovligt")
                        }
                        .buttonStyle(Resources.CustomButtonStyle.ActionButtonStyle())

                        Button {
                            studentAbsenceState = "S"
                            students.absenceStringState(studentState: studentAbsenceState, index: studentIndex)
                            showSheet.toggle()
                        } label: {
                            Text("Syg")
                        }
                        .buttonStyle(Resources.CustomButtonStyle.ActionButtonStyle())

                        Button {
                            studentAbsenceState = ""
                            students.absenceStringState(studentState: studentAbsenceState, index: studentIndex)
                            showSheet.toggle()
                        } label: {
                            Text("Ryd")
                        }
                        .buttonStyle(Resources.CustomButtonStyle.ActionButtonStyle())
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
