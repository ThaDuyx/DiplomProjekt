//
//  StudentClassListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 16/03/2022.
//

import SwiftUI

struct StudentClassListView: View {
    @ObservedObject var registrationManager = RegistrationManager()
    @State private var showSheet: Bool = false
    @State private var studentAbsenceState: String = ""
    @State private var studentIndex: Int = 0
    @State private var studentName: String = ""
    
    var selectedClass: String
    
    init(selectedClass: String) {
        self.selectedClass = selectedClass
        self.registrationManager.fetchRegistrations(className: selectedClass)
    }
    
    var body: some View {
        ZStack{
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            Form {
                Section {
                    HStack(alignment: .center) {
                        Spacer()
                        VStack {
                            Text(selectedClass)
                                .darkBodyTextStyle()
                            Text(Date().currentDateAndNameFormatted)
                                .darkBodyTextStyle()
                        }
                        Spacer()
                        Button {
                            registrationManager.saveRegistrations(className: selectedClass)
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Resources.Color.Colors.darkBlue)
                        }
                    }
                }
                .listRowBackground(Color.clear)
                Section {
                    ForEach(0..<registrationManager.registrations.count, id: \.self) { index in
                        StudentSection(
                            index: "\(index+1)",
                            name: registrationManager.registrations[index].studentName,
                            absenceState: registrationManager.registrations[index].reason
                        )
                            .onTapGesture {
                                if !studentAbsenceState.isEmpty {
                                    studentAbsenceState = ""
                                }

                                studentName = registrationManager.registrations[index].studentName
                                studentIndex = index
                                showSheet.toggle()
                            }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .halfSheet(showSheet: $showSheet) {
                ZStack {
                    Resources.BackgroundGradient.backgroundGradient
                        .ignoresSafeArea()
                    VStack {
                        Text("student_list_absence_description \(studentName)")
                            .darkBodyTextStyle()
                        Button {
                            studentAbsenceState = "FS"
                            registrationManager.setAbsenceReason(absenceReason: studentAbsenceState, index: studentIndex)
                            showSheet.toggle()
                        } label: {
                            Text("student_list_absence_late")
                        }
                        .buttonStyle(Resources.CustomButtonStyle.FilledButtonStyle())

                        Button {
                            studentAbsenceState = "U"
                            registrationManager.setAbsenceReason(absenceReason: studentAbsenceState, index: studentIndex)
                            showSheet.toggle()
                        } label: {
                            Text("student_list_absence_illegal")
                        }
                        .buttonStyle(Resources.CustomButtonStyle.FilledButtonStyle())

                        Button {
                            studentAbsenceState = "S"
                            registrationManager.setAbsenceReason(absenceReason: studentAbsenceState, index: studentIndex)
                            showSheet.toggle()
                        } label: {
                            Text("student_list_absence_sick")
                        }
                        .buttonStyle(Resources.CustomButtonStyle.FilledButtonStyle())

                        Button {
                            studentAbsenceState = ""
                            registrationManager.setAbsenceReason(absenceReason: studentAbsenceState, index: studentIndex)
                            showSheet.toggle()
                        } label: {
                            Text("student_list_absence_clear")
                        }
                        .buttonStyle(Resources.CustomButtonStyle.FilledButtonStyle())
                    }
                }
                .ignoresSafeArea()
            } onEnd: {
                showSheet.toggle()
            }
        }
        .navigationTitle("Registrer")
        .navigationBarTitleDisplayMode(.inline)
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
        StudentClassListView(selectedClass: "")
    }
}
