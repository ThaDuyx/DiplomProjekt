//
//  AbsenceRegistrationView.swift
//  Registr
//
//  Created by Christoffer Detlef on 15/04/2022.
//

import SwiftUI

enum AbsenceReasons: String, CaseIterable {
    case Illegal = "Ulovligt"
    case late = "For sent"
    case sick = "Syg"
    case clear = ""
}

struct AbsenceRegistrationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var registrationManager: RegistrationManager

    let currentDate = Date.now
    let comingDays = Date().comingDays(days: 7)
    let previousDays = Date().previousDays(days: 7)

    @State private var selectedItem: Int? = nil
    @State private var selectedTime: Int = 1
    @State private var showSheet: Bool = false
    @State private var studentAbsenceState: String = ""
    @State private var studentIndex: Int = 0
    @State private var studentName: String = ""

    var selectedClass: String
    var selectedDate: String
    
    init(selectedClass: String, selectedDate: String) {
        self.selectedClass = selectedClass
        self.selectedDate = selectedDate
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { proxy in
                        HStack(spacing: 65) {
                            ForEach(Array(convertedArray(currentDay: currentDate, previousDays: previousDays, comingDays: comingDays).enumerated()), id: \.offset) { number, element in
                                VStack {
                                    if element == currentDate {
                                        Text("I dag")
                                            .bigBodyTextStyle(color: Resources.Color.Colors.fiftyfifty)
                                    }
                                    
                                    Text("\(element.formatSpecificToDayAndMonthData(date: element))")
                                        .boldSubTitleTextStyle(color: self.selectedItem == number ? Resources.Color.Colors.frolyRed : Resources.Color.Colors.fiftyfifty)
                                }
                                .id(number)
                                .onTapGesture {
                                    self.selectedItem = number
                                }
                            }.onAppear {
                                withAnimation(.spring()) {
                                    proxy.scrollTo(7, anchor: .center)
                                    self.selectedItem = 7
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Button {
                        selectedTime = 1
                    } label: {
                        Text("Formiddag")
                            .mediumSubTitleTextStyle(color: selectedTime == 1 ? Resources.Color.Colors.frolyRed : Resources.Color.Colors.fiftyfifty, font: selectedTime == 1 ? "Poppins-Medium" : "Poppins-Regular")
                    }
                    .frame(maxWidth: .infinity, minHeight: 35)
                    .background(selectedTime == 1 ? .white : Resources.Color.Colors.fiftyfifty.opacity(0.15) )
                    
                    Button {
                        selectedTime = 2
                    } label: {
                        Text("Eftermiddag")
                        .mediumSubTitleTextStyle(color: selectedTime == 2 ? Resources.Color.Colors.frolyRed : Resources.Color.Colors.fiftyfifty, font: selectedTime == 2 ? "Poppins-Medium" : "Poppins-Regular")                    }
                    .frame(maxWidth: .infinity, minHeight: 35)
                    .background(selectedTime == 2 ? .white : Resources.Color.Colors.fiftyfifty.opacity(0.15) )
                }
                
                ScrollView {
                    ForEach(0..<registrationManager.registrations.count, id: \.self) { index in
                        StudentRow(
                            index: index+1,
                            studentName: registrationManager.registrations[index].studentName,
                            absenceReason: registrationManager.registrations[index].reason
                        )
                            .onTapGesture {
                                if !studentAbsenceState.isEmpty {
                                    studentAbsenceState = ""
                                }
                                studentIndex = index
                                studentName = registrationManager.registrations[index].studentName
                                showSheet.toggle()
                            }
                        
                        Divider()
                            .background(Resources.Color.Colors.fiftyfifty)
                    }
                }
                .listStyle(.plain)
                .halfSheet(showSheet: $showSheet) {
                    VStack {
                        Text("student_list_absence_description \(studentName)")
                            .boldDarkBodyTextStyle()
                        
                        ForEach(AbsenceReasons.allCases, id: \.self) { absenceReasons in
                            Button(absenceReasons.rawValue.isEmpty ? "Ryd felt" : absenceReasons.rawValue) {
                                studentAbsenceState = absenceReasons.rawValue
                                registrationManager.setAbsenceReason(absenceReason: studentAbsenceState, index: studentIndex)
                                showSheet.toggle()
                            }
                            .buttonStyle(Resources.CustomButtonStyle.FilledWideButtonStyle())
                        }

                    }
                } onEnd: {
                    showSheet.toggle()
                }
                
                Button {
                    registrationManager.saveRegistrations(className: selectedClass, date: selectedDate) { result in
                        if result {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            // TODO: Present ErrorView
                        }
                    }
                } label: {
                    Text("Gem")
                }
                .buttonStyle(Resources.CustomButtonStyle.FilledWideButtonStyle())
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Registrer")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            registrationManager.fetchRegistrations(className: selectedClass, date: selectedDate)
        }
    }
}

private func convertedArray(currentDay: Date, previousDays: [Date], comingDays: [Date]) -> [Date]{
    let reversedPreviousDays = previousDays.reversed()
    
    var array: [Date] = []
    
    array.append(contentsOf: reversedPreviousDays)
    array.insert(currentDay, at: 7)
    array.append(contentsOf: comingDays)

    return array
}

struct StudentRow: View {
    let index: Int
    let studentName: String
    let absenceReason: String?
    
    init(index: Int, studentName: String, absenceReason: String?) {
        self.index = index
        self.studentName = studentName
        self.absenceReason = absenceReason
    }
    var body: some View {
        HStack {
            Text("\(index)")
                .boldSubTitleTextStyle(color: Resources.Color.Colors.fiftyfifty)
                .padding(.leading, 20)
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Resources.Color.Colors.fiftyfifty)
            
            Text(studentName)
                .mediumSubTitleTextStyle(color: absenceReason?.isEmpty ?? true ? Resources.Color.Colors.fiftyfifty : Resources.Color.Colors.frolyRed, font: "Poppins-Regular")
            
            Spacer()
            
            Button { } label: {
                Text(absenceReason?.isEmpty ?? true ? "" : stringSeparator(reason: absenceReason ?? "").uppercased())
                    .frame(width: 35, height: 35)
                    .foregroundColor(Resources.Color.Colors.frolyRed)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(absenceReason?.isEmpty ?? true ? Resources.Color.Colors.fiftyfifty : Resources.Color.Colors.frolyRed, lineWidth: 2)
            )
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity, minHeight: 80)
    }
}

struct AbsenceRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceRegistrationView(selectedClass: "", selectedDate: "")
    }
}
