//
//  AbsenceRegistrationView.swift
//  Registr
//
//  Created by Christoffer Detlef on 15/04/2022.
//

import SwiftUI

struct AbsenceRegistrationView: View {
    // Managers
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var registrationViewModel: RegistrationViewModel
    @EnvironmentObject var classViewModel: ClassViewModel
    @StateObject var statisticsViewModel = StatisticsViewModel()
    @StateObject var errorHandling = ErrorHandling()
    
    // State variables
    @State private var selectedItem: Int? = nil
    @State private var isMorning: Bool = true
    @State private var showSheet: Bool = false
    @State private var studentAbsenceState: String = ""
    @State private var studentIndex: Int = 0
    @State private var studentName: String = ""
    @State private var elementDate = Date()
    @State private var selectedDate = Date()
    @State private var isPresented = false
    
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
                        Text("ar_day_picked".localize)
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
                                            Text("ar_today".localize)
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
                                        withAnimation(.spring()) {
                                            proxy.scrollTo(selectedItem, anchor: .center)
                                        }
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
                            Text("statistics_morning".localize)
                                .subTitleTextStyle(color: isMorning ? .frolyRed : .fiftyfifty, font: isMorning ? .poppinsMedium : .poppinsRegular)
                        }
                        .frame(maxWidth: .infinity, minHeight: 35)
                        .background(isMorning ? .white : Color.fiftyfifty.opacity(0.15) )
                        
                        Button {
                            isMorning = false
                        } label: {
                            Text("statistics_afternoon".localize)
                                .subTitleTextStyle(color: !isMorning ? .frolyRed : .fiftyfifty, font: !isMorning ? .poppinsMedium : .poppinsRegular)
                        }
                        .frame(maxWidth: .infinity, minHeight: 35)
                        .background(!isMorning ? .white : .fiftyfifty.opacity(0.15) )
                    }
                }
                if Calendar.current.isDateInWeekend(isFromHistory ? selectedDate : elementDate) {
                    Spacer()
                    
                    Text("ar_day_is_weekend".localize)
                        .headerTextStyle(color: .frolyRed, font: .poppinsSemiBold)
                        .frame(alignment: .center)
                    
                    Spacer()
                } else {
                    if isMorning && registrationViewModel.registrationInfo.hasMorningBeenRegistrered  || !isMorning && registrationViewModel.registrationInfo.hasAfternoonBeenRegistrered {
                        HStack {
                            Text("ar_registration_completed".localize)
                                .bodyTextStyle(color: .completionGreen, font: .poppinsMedium)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.completionGreen)
                        }
                        .padding(.top, 10)
                    }
                    
                    ScrollView {
                        ForEach(0..<registrationViewModel.registrations.count, id: \.self) { index in
                            RegistrationStudentSection(
                                index: index+1,
                                studentName: registrationViewModel.registrations[index].studentName,
                                absenceReason: registrationViewModel.registrations[index].reason.rawValue,
                                studentID: registrationViewModel.registrations[index].studentID,
                                isMorning: isMorning,
                                selectedDate: selectedDate
                            )
                                .environmentObject(statisticsViewModel)
                                .onTapGesture {
                                    if !studentAbsenceState.isEmpty {
                                        studentAbsenceState = ""
                                    }
                                    studentIndex = index
                                    studentName = registrationViewModel.registrations[index].studentName
                                    showSheet = true
                                }
                            
                            Divider()
                                .background(Color.fiftyfifty)
                        }
                    }
                    .accessibilityIdentifier("studentScrollView")
                    .halfSheet(showSheet: $showSheet) {
                        
                        VStack {
                            Text("student_list_absence_description \(studentName)")
                                .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                            
                            ForEach(RegistrationType.allCases, id: \.self) { absenceReasons in
                                Button(absenceReasons.rawValue.isEmpty ? "ar_empty_field".localize : absenceReasons.rawValue) {
                                    studentAbsenceState = absenceReasons.rawValue
                                    registrationViewModel.setAbsenceReason(absenceReason: absenceReasons, index: studentIndex)
                                    showSheet.toggle()
                                }
                                .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsSemiBold, fontSize: Resources.FontSize.primaryHeader))
                            }
                        }
                    } onEnd: {
                        showSheet = false
                    }
                    
                    Button {
                        registrationViewModel.saveRegistrations(classID: selectedClass.classID, date: selectedDate.formatSpecificDate(date: selectedDate), isMorning: isMorning) { result in
                            if result {
                                statisticsViewModel.commitBatch()
                                statisticsViewModel.writeClassStats(classID: selectedClass.classID, isMorning: isMorning, date: selectedDate)
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                isPresented.toggle()
                            }
                        }
                    } label: {
                        Text("ar_save".localize)
                    }
                    .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsSemiBold, fontSize: Resources.FontSize.primaryHeader))
                    .padding(.bottom, 20)
                }
            }
            .fullScreenCover(isPresented: $isPresented, content: {
                ErrorView(title: "alert_title".localize, error: "alert_default_description".localize)
            })
            .fullScreenCover(item: $errorHandling.appError, content: { appError in
                ErrorView(title: appError.title, error: appError.description) {
                    if appError.type == .registrationManagerError {
                        classViewModel.fetchClasses()
                        registrationViewModel.fetchRegistrations(classID: selectedClass.classID, date: selectedDate.formatSpecificDate(date: selectedDate), isMorning: isMorning)
                    } else if appError.type == .statisticsManagerError {
                        statisticsViewModel.commitBatch()
                    } else if appError.type == .registrationManagerInitError {
                        classViewModel.fetchClasses()
                    }
                }
            })
            .navigationTitle("ar_navigationtitle".localize)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear() {
                registrationViewModel.fetchRegistrations(classID: selectedClass.classID, date: selectedDate.formatSpecificDate(date: selectedDate), isMorning: isMorning)
            }
            .onChange(of: selectedDate.formatSpecificDate(date: selectedDate)) { newDate in
                registrationViewModel.fetchRegistrations(classID: selectedClass.classID, date: newDate, isMorning: isMorning)
                
                // Resetting on change of date
                statisticsViewModel.resetStatCounters()
                statisticsViewModel.resetBatch()
            }
            .onChange(of: isMorning) { _ in
                registrationViewModel.fetchRegistrations(classID: selectedClass.classID, date: selectedDate.formatSpecificDate(date: selectedDate), isMorning: isMorning)
                statisticsViewModel.resetStatCounters()
                statisticsViewModel.resetBatch()
            }
            .onChange(of: selectedClass) { _ in
                // Resetting on change of class
                statisticsViewModel.resetStatCounters()
                statisticsViewModel.resetBatch()
            }
        }
    }
}

private func convertedArray(currentDay: Date, previousDays: [Date], comingDays: [Date]) -> [Date]{
    let reversedPreviousDays = previousDays.reversed()
    
    var dateArray: [Date] = []
    
    dateArray.append(contentsOf: reversedPreviousDays)
    dateArray.insert(currentDay, at: 7)
    dateArray.append(contentsOf: comingDays)
    
    return dateArray
}

struct AbsenceRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceRegistrationView(selectedClass: ClassInfo(isDoubleRegistrationActivated: false, name: "", classID: ""), selectedDate: .now, isFromHistory: false)
    }
}
