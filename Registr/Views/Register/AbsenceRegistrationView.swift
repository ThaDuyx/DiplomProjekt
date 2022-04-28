//
//  AbsenceRegistrationView.swift
//  Registr
//
//  Created by Christoffer Detlef on 15/04/2022.
//

import SwiftUI
import SwiftUIKit

enum AbsenceReasons: String, CaseIterable {
    case illegal = "Ulovligt"
    case illness = "Syg"
    case late = "For sent"
    case clear = ""
}

struct AbsenceRegistrationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var registrationManager: RegistrationManager
    @StateObject var statisticsManager = StatisticsManager()
    @StateObject private var context = FullScreenCoverContext()
    
    
    let currentDate = Date.now
    let comingDays = Date().comingDays(days: 7)
    let previousDays = Date().previousDays(days: 7)
    
    @State private var selectedItem: Int? = nil
    @State private var isMorning: Bool = true
    @State private var showSheet: Bool = false
    @State private var studentAbsenceState: String = ""
    @State private var studentIndex: Int = 0
    @State private var studentName: String = ""
    @State var elementDate = Date()
    @State var selectedDate: String
    var isFromHistory: Bool
    
    var selectedClass: ClassInfo
    
    
    init(selectedClass: ClassInfo, selectedDate: String, isFromHistory: Bool) {
        self.selectedClass = selectedClass
        _selectedDate = State(initialValue: selectedDate)
        self.isFromHistory = isFromHistory
    }
    
    var body: some View {
        ZStack {
            VStack {
                if isFromHistory {
                    VStack {
                        Text("Valgte dag")
                            .bigBodyTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
                        
                        Text(selectedDate)
                            .subTitleTextStyle(color: .frolyRed, font: .poppinsBold)
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        ScrollViewReader { proxy in
                            HStack(spacing: 65) {
                                ForEach(Array(convertedArray(currentDay: currentDate, previousDays: previousDays, comingDays: comingDays).enumerated()), id: \.offset) { number, element in
                                    VStack {
                                        if element == currentDate {
                                            Text("I dag")
                                                .bigBodyTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
                                        }
                                        
                                        Text("\(element.formatSpecificToDayAndMonthDate(date: element))")
                                            .subTitleTextStyle(color: self.selectedItem == number ? .frolyRed : Color.fiftyfifty, font: .poppinsBold)
                                    }
                                    .id(number)
                                    .onTapGesture {
                                        self.selectedItem = number
                                        selectedDate = element.formatSpecificDate(date: element)
                                        elementDate = element
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
                }
                
                if selectedClass.isDoubleRegistrationActivated {
                    HStack {
                        Button {
                            isMorning = true
                        } label: {
                            Text("Formiddag")
                                .subTitleTextStyle(color: isMorning ? .frolyRed : .fiftyfifty, font: isMorning ? .poppinsMedium : .poppinsRegular)
                        }
                        .frame(maxWidth: .infinity, minHeight: 35)
                        .background(isMorning ? .white : Color.fiftyfifty.opacity(0.15) )
                        
                        Button {
                            isMorning = false
                        } label: {
                            Text("Eftermiddag")
                                .subTitleTextStyle(color: !isMorning ? .frolyRed : .fiftyfifty, font: !isMorning ? .poppinsMedium : .poppinsRegular)
                        }
                        .frame(maxWidth: .infinity, minHeight: 35)
                        .background(!isMorning ? .white : .fiftyfifty.opacity(0.15) )
                    }
                }
                if Calendar.current.isDateInWeekend(elementDate) {
                    Spacer()
                    
                    Text("Den valgte dato er en weekend")
                        .headerTextStyle(color: .frolyRed, font: .poppinsSemiBold)
                        .frame(alignment: .center)
                    Spacer()
                } else {
                    if isMorning && registrationManager.registrationInfo.hasMorningBeenRegistrered  || !isMorning && registrationManager.registrationInfo.hasAfternoonBeenRegistrered{
                        HStack {
                            Text("Fraværsregistrering gennemgået")
                                .bodyTextStyle(color: .completionGreen, font: .poppinsMedium)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.completionGreen)
                        }
                        .padding(.top, 10)
                    }
                    
                    ScrollView {
                        ForEach(0..<registrationManager.registrations.count, id: \.self) { index in
                            StudentRow(
                                index: index+1,
                                studentName: registrationManager.registrations[index].studentName,
                                absenceReason: registrationManager.registrations[index].reason,
                                studentID: registrationManager.registrations[index].studentID,
                                isMorning: isMorning
                            )
                                .environmentObject(statisticsManager)
                                .onTapGesture {
                                    if !studentAbsenceState.isEmpty {
                                        studentAbsenceState = ""
                                    }
                                    studentIndex = index
                                    studentName = registrationManager.registrations[index].studentName
                                    showSheet.toggle()
                                }
                            
                            Divider()
                                .background(Color.fiftyfifty)
                        }
                    }
                    .listStyle(.plain)
                    .halfSheet(showSheet: $showSheet) {
                        
                        VStack {
                            Text("student_list_absence_description \(studentName)")
                                .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                            
                            ForEach(AbsenceReasons.allCases, id: \.self) { absenceReasons in
                                Button(absenceReasons.rawValue.isEmpty ? "Ryd felt" : absenceReasons.rawValue) {
                                    studentAbsenceState = absenceReasons.rawValue
                                    registrationManager.setAbsenceReason(absenceReason: studentAbsenceState, index: studentIndex)
                                    showSheet.toggle()
                                }
                                .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsSemiBold, fontSize: Resources.FontSize.primaryHeader))
                            }
                        }
                    } onEnd: {
                        showSheet.toggle()
                    }
                    
                    Button {
                        registrationManager.saveRegistrations(className: selectedClass.name, date: selectedDate, isMorning: isMorning) { result in
                            if result {
                                statisticsManager.commitBatch()
                                statisticsManager.writeClassStats(className: selectedClass.name, isMorning: isMorning)
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                context.present(ErrorView(error: "alert_default_description".localize))
                            }
                        }
                    } label: {
                        Text("Gem")
                    }
                    .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsSemiBold, fontSize: Resources.FontSize.primaryHeader))
                    .padding(.bottom, 20)
                }
            }
            .fullScreenCover(context)
            .navigationTitle("Registrer")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear() {
                registrationManager.fetchRegistrations(className: selectedClass.name, date: selectedDate, isMorning: isMorning)
            }
            .onChange(of: selectedDate) { newDate in
                registrationManager.fetchRegistrations(className: selectedClass.name, date: newDate, isMorning: isMorning)
                
                // Resetting on change of date
                statisticsManager.resetStatCounters()
                statisticsManager.resetBatch()
            }
            .onChange(of: isMorning) { _ in
                registrationManager.fetchRegistrations(className: selectedClass.name, date: selectedDate, isMorning: isMorning)
                statisticsManager.resetStatCounters()
                statisticsManager.resetBatch()
            }
            .onChange(of: selectedClass) { _ in
                // Resetting on change of class
                statisticsManager.resetStatCounters()
                statisticsManager.resetBatch()
            }
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
    @EnvironmentObject var registrationManager: RegistrationManager
    @EnvironmentObject var statisticsManager: StatisticsManager
    
    let index: Int
    let studentName: String
    let absenceReason: String?
    let studentID: String
    let isMorning: Bool
    
    init(index: Int, studentName: String, absenceReason: String?, studentID: String, isMorning: Bool) {
        self.index = index
        self.studentName = studentName
        self.absenceReason = absenceReason
        self.studentID = studentID
        self.isMorning = isMorning
    }
    
    var body: some View {
        HStack {
            Text("\(index)")
                .subTitleTextStyle(color: Color.fiftyfifty, font: .poppinsBold)
                .padding(.leading, 20)
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.fiftyfifty)
            
            Text(studentName)
                .subTitleTextStyle(color: absenceReason?.isEmpty ?? true ? Color.fiftyfifty : .frolyRed, font: .poppinsRegular)
            
            Spacer()
            
            Button { } label: {
                Text(absenceReason?.isEmpty ?? true ? "" : stringSeparator(reason: absenceReason ?? "").uppercased())
                    .frame(width: 35, height: 35)
                    .foregroundColor(.frolyRed)
                // Note: absenceReason in the following code is the old state value.
                    .onChange(of: absenceReason) { [absenceReason] newValue in
                        // Force un-wrapping because we know we have the values and would like to receive an empty String
                        statisticsManager.updateClassStatistics(oldValue: absenceReason!, newValue: newValue!)
                        statisticsManager.updateStudentStatistics(oldValue: absenceReason!, newValue: newValue!, studentID: studentID, isMorning: isMorning)
                    }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(absenceReason?.isEmpty ?? true ? Color.fiftyfifty : .frolyRed, lineWidth: 2)
            )
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity, minHeight: 80)
    }
}

struct AbsenceRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceRegistrationView(selectedClass: ClassInfo(isDoubleRegistrationActivated: false, name: ""), selectedDate: "", isFromHistory: false)
    }
}
