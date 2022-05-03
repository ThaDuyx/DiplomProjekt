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
    // Managers
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var registrationManager: RegistrationManager
    @StateObject var statisticsManager = StatisticsManager()
    @StateObject private var context = FullScreenCoverContext()
    
    // State variables
    @State private var selectedItem: Int? = nil
    @State private var isMorning: Bool = true
    @State private var showSheet: Bool = false
    @State private var studentAbsenceState: String = ""
    @State private var studentIndex: Int = 0
    @State private var studentName: String = ""
    @State private var elementDate = Date()
    @State private var selectedDate = Date()
    
    // Date selectors
    private let currentDate = Date.now
    private let comingDays = Date().comingDays(days: 7)
    private let previousDays = Date().previousDays(days: 7)
    
    // Operator
    private var isFromHistory: Bool
    
    // Selector
    private var selectedClass: ClassInfo
    
    init(selectedClass: ClassInfo, selectedDate: Date, isFromHistory: Bool) {
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
                        
                        Text(selectedDate.formatSpecificDate(date: selectedDate))
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
                                        selectedDate = element
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
                if Calendar.current.isDateInWeekend(isFromHistory ? selectedDate : elementDate) {
                    Spacer()
                    
                    Text("Den valgte dato er en weekend")
                        .headerTextStyle(color: .frolyRed, font: .poppinsSemiBold)
                        .frame(alignment: .center)
                    
                    Spacer()
                } else {
                    if isMorning && registrationManager.registrationInfo.hasMorningBeenRegistrered  || !isMorning && registrationManager.registrationInfo.hasAfternoonBeenRegistrered {
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
                            RegistrationStudentSection(
                                index: index+1,
                                studentName: registrationManager.registrations[index].studentName,
                                absenceReason: registrationManager.registrations[index].reason,
                                studentID: registrationManager.registrations[index].studentID,
                                isMorning: isMorning,
                                selectedDate: selectedDate
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
                        registrationManager.saveRegistrations(className: selectedClass.name, date: selectedDate.formatSpecificDate(date: selectedDate), isMorning: isMorning) { result in
                            if result {
                                statisticsManager.commitBatch()
                                statisticsManager.writeClassStats(className: selectedClass.name, isMorning: isMorning, date: selectedDate)
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                context.present(ErrorView(title: "alert_title".localize, error: "alert_default_description".localize))
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
            .fullScreenCover(item: $statisticsManager.appError, content: { appError in
                ErrorView(title: appError.title, error: appError.description) {
                    statisticsManager.commitBatch()
                }
            })
            .fullScreenCover(item: $registrationManager.appError, content: { appError in
                ErrorView(title: appError.title, error: appError.description) {
                    registrationManager.fetchClasses()
                    registrationManager.fetchRegistrations(className: selectedClass.name, date: selectedDate.formatSpecificDate(date: selectedDate), isMorning: isMorning)
                }
            })
            .navigationTitle("Registrer")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear() {
                registrationManager.fetchRegistrations(className: selectedClass.name, date: selectedDate.formatSpecificDate(date: selectedDate), isMorning: isMorning)
            }
            .onChange(of: selectedDate.formatSpecificDate(date: selectedDate)) { newDate in
                registrationManager.fetchRegistrations(className: selectedClass.name, date: newDate, isMorning: isMorning)
                
                // Resetting on change of date
                statisticsManager.resetStatCounters()
                statisticsManager.resetBatch()
            }
            .onChange(of: isMorning) { _ in
                registrationManager.fetchRegistrations(className: selectedClass.name, date: selectedDate.formatSpecificDate(date: selectedDate), isMorning: isMorning)
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

struct AbsenceRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceRegistrationView(selectedClass: ClassInfo(isDoubleRegistrationActivated: false, name: ""), selectedDate: .now, isFromHistory: false)
    }
}
