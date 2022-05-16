//
//  ParentAbsenceRegistrationView.swift
//  Registr
//
//  Created by Christoffer Detlef on 31/03/2022.
//

import SwiftUI

struct ParentAbsenceRegistrationView: View {
    // Manager objects
    @StateObject var errorHandling = ErrorHandling()
    @StateObject private var schoolManager = SchoolManager()
    @EnvironmentObject var childrenManager: ChildrenManager
    @ObservedObject var textBindingManager = TextBindingManager(limit: 150)
    @Environment(\.dismiss) var dismiss
    
    // States variables
    @State private var isPresented = false
    @State private var selectedAbsenceString = ""
    @State private var selectedAbsenceType: AbsenceType = .late
    @State private var selectedTimeOfDayString = ""
    @State private var selectedTimeOfDayType: TimeOfDay = .morning
    @State private var selectedRegistrationType: RegistrationType = .notRegistered
    @State private var selectedName = ""
    @State private var selectedChild: Student?
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isDoubleRegistrationActivated = false
    @State private var isInterval = false
    @State private var showsStartDatePicker = false
    @State private var showsEndDatePicker = false
    @State private var showingAlert = false
    @State private var isReportAlert = false
    @State private var shouldDismiss = false
    @FocusState private var focusedField: Field?
    
    // Selectors
    private let report: Report?
    private let absence: Registration?
    private let child: Student?
    
    // Operators
    private let shouldUpdate: Bool
    private let isAbsenceChange: Bool
    
    // For dismissing the keyboard
    enum Field: Hashable {
        case myField
    }
    
    init(report: Report?, absence: Registration?, child: Student?, shouldUpdate: Bool, isAbsenceChange: Bool) {
        self.report = report
        self.absence = absence
        self.child = child
        self.shouldUpdate = shouldUpdate
        self.isAbsenceChange = isAbsenceChange
        
        if let availableReport = report {
            _selectedAbsenceString = State(initialValue: availableReport.reason.rawValue)
            _selectedAbsenceType = State(initialValue: availableReport.reason)
            _selectedRegistrationType = State(initialValue: availableReport.registrationType)
            _isDoubleRegistrationActivated = State(initialValue: availableReport.isDoubleRegistrationActivated)
            _selectedTimeOfDayType = State(initialValue: availableReport.timeOfDay)
            _selectedTimeOfDayString = State(initialValue: availableReport.timeOfDay.rawValue)
            _startDate = State(initialValue: availableReport.date)
            
            if let availableEndDate = availableReport.endDate {
                _isInterval = State(initialValue: true)
                _endDate = State(initialValue: availableEndDate)
            }
            
            if let availableDescription = availableReport.description {
                textBindingManager.value = availableDescription
            }
        }
        
        if let availableAbsence = absence {
            _selectedAbsenceString = State(initialValue: availableAbsence.reason.rawValue)
            _isDoubleRegistrationActivated = State(initialValue: false)
            _selectedTimeOfDayType = State(initialValue: availableAbsence.isMorning ? .morning : .afternoon)
            _selectedTimeOfDayString = State(initialValue: availableAbsence.isMorning ? TimeOfDay.morning.rawValue : TimeOfDay.afternoon.rawValue)
            _startDate = State(initialValue: availableAbsence.date.dateFromString)
            _selectedRegistrationType = State(initialValue: availableAbsence.reason)
        }
        
        if let availableChild = child {
            _selectedChild = State(initialValue: availableChild)
            _selectedName = State(initialValue: availableChild.name)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(
                        header:
                            Text("parent_absence_registration_kid")
                            .bodyTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
                    ) {
                        Menu {
                            ForEach(childrenManager.children, id: \.self) { child in
                                Button(child.name + " - " + child.className) {
                                    selectedName = child.name
                                    selectedChild = child
                                    isDoubleRegistrationActivated = child.classInfo.isDoubleRegistrationActivated
                                    selectedTimeOfDayType = .morning
                                }
                                .disabled(shouldUpdate || isAbsenceChange)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(Color.white)
                                Text(selectedName.isEmpty ? "parent_absence_registration_pick_kid".localize : selectedName)
                                    .bodyTextStyle(color: .white, font: .poppinsRegular)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .listRowBackground(Color.frolyRed)
                    
                    if selectedChild != nil {
                        Section(
                            header:
                                Text("parent_absence_registration_reason")
                                .bodyTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
                        ) {
                            Menu {
                                ForEach(AbsenceType.allCases, id: \.self) { absenceType in
                                    Button(absenceType.rawValue) {
                                        selectedAbsenceString = absenceType.rawValue
                                        selectedAbsenceType = absenceType
                                        switch absenceType {
                                        case .illness:
                                            selectedRegistrationType = .illness
                                        case .late:
                                            selectedRegistrationType = .late
                                        case .prolongedIllness, .vacation:
                                            selectedRegistrationType = .legal
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "questionmark")
                                        .foregroundColor(.white)
                                    Text(selectedAbsenceString.isEmpty ? "parent_absence_registration_pick_reason".localize : selectedAbsenceString)
                                        .bodyTextStyle(color: .white, font: .poppinsRegular)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .listRowBackground(Color.frolyRed)
                        .accessibilityIdentifier("absenceReasonMenu")

                        if isDoubleRegistrationActivated {
                            Section(
                                header:
                                    Text("parent_absence_registration_time")
                                    .bodyTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
                            ) {
                                Menu {
                                    ForEach(TimeOfDay.allCases, id: \.self) { timeType in
                                        Button(timeType.rawValue) {
                                            selectedTimeOfDayString = timeType.rawValue
                                            selectedTimeOfDayType = timeType
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "clock")
                                            .foregroundColor(.white)
                                        Text(selectedTimeOfDayString.isEmpty ? "parent_absence_registration_pick_time".localize : selectedTimeOfDayString)
                                            .bodyTextStyle(color: .white, font: .poppinsRegular)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .listRowBackground(Color.frolyRed)
                        }
                        if !isAbsenceChange {
                            Section(
                                header:
                                    Text("parent_absence_registration_interval")
                                    .bodyTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
                            ) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.white)
                                    Toggle("parent_absence_registration_enable_end_date".localize, isOn: $isInterval)
                                        .textStyleToggle(color: .white, font: .poppinsRegular, size: Resources.FontSize.body)
                                        .toggleStyle(SwitchToggleStyle(tint: .white.opacity(0.5)))
                                }
                            }
                            .listRowBackground(Color.frolyRed)
                        }
                        
                        Section(
                            header:
                                Text("parent_absence_registration_start_date")
                                .bodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
                        ) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.white)
                                Text(DateFormatter.abbreviationDayMonthYearFormatter.string(from: startDate))
                                    .bodyTextStyle(color: .white, font: .poppinsRegular)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .onTapGesture {
                                        if !isAbsenceChange {
                                            self.showsStartDatePicker.toggle()
                                        }
                                    }
                            }
                            if showsStartDatePicker {
                                if let school = schoolManager.school {
                                    DatePicker(
                                        "",
                                        selection: $startDate,
                                        in: dateRanges(amountOfDaysSinceStart: dateClosedRange(date: school.startDate), amountOfDayssinceStop: dateClosedRange(date: school.endDate)),
                                        displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .applyTextColor(Color.white)
                                }
                            }
                        }
                        .listRowBackground(Color.frolyRed)
                        
                        if isInterval {
                            Section(
                                header:
                                    Text("parent_absence_registration_end_date")
                                    .bodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
                            ) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.white)
                                    Text(DateFormatter.abbreviationDayMonthYearFormatter.string(from: endDate))
                                        .bodyTextStyle(color: .white, font: .poppinsRegular)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .onTapGesture {
                                            self.showsEndDatePicker.toggle()
                                        }
                                }
                                if showsEndDatePicker {
                                    if let school = schoolManager.school {
                                        DatePicker(
                                            "",
                                            selection: $endDate,
                                            in: dateRanges(amountOfDaysSinceStart: dateClosedRange(date: school.startDate), amountOfDayssinceStop: dateClosedRange(date: school.endDate)),
                                            displayedComponents: .date)
                                        .datePickerStyle(.graphical)
                                        .applyTextColor(.white)
                                    }
                                }
                            }
                            .listRowBackground(Color.frolyRed)
                        }
                        
                        Section(
                            header:
                                Text("parent_absence_registration_description")
                                .bodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
                        ) {
                            HStack {
                                Image(systemName: "note.text")
                                    .foregroundColor(.white)
                                ZStack(alignment: .leading) {
                                    TextEditor(text: $textBindingManager.value)
                                        .textStyleTextEditor(color: .white, font: .poppinsRegular, size: Resources.FontSize.body)
                                        .accentColor(.white)
                                        .focused($focusedField, equals: .myField)
                                        .onTapGesture {
                                            if (focusedField != nil) {
                                                focusedField = nil
                                            }
                                        }
                                        .accessibilityIdentifier("writeDescriptionForAbsence")
                                }
                            }
                        }
                        .listRowBackground(Color.frolyRed)
                        
                        VStack(alignment: .center) {
                            Button(shouldUpdate ? "par_update".localize : "par_report".localize) {
                                if selectedName.isEmpty || selectedAbsenceString.isEmpty || isDoubleRegistrationActivated && selectedTimeOfDayString.isEmpty {
                                    showingAlert = true
                                    isReportAlert = false
                                }else if checkReport(), !shouldUpdate {
                                    showingAlert = true
                                    isReportAlert = true
                                } else {
                                    if let selectedChild = selectedChild, let name = UserManager.shared.user?.name, let id = selectedChild.id, !selectedAbsenceString.isEmpty, selectedRegistrationType != .notRegistered {
                                        let report = Report(id: shouldUpdate ? report?.id : nil,
                                                            parentName: name,
                                                            parentID: DefaultsManager.shared.currentProfileID,
                                                            studentName: selectedChild.name,
                                                            studentID: id,
                                                            className: selectedChild.className,
                                                            classID: selectedChild.classInfo.classID,
                                                            date: startDate,
                                                            endDate: isInterval ? endDate : nil,
                                                            timeOfDay: isDoubleRegistrationActivated ? selectedTimeOfDayType : .morning,
                                                            description: textBindingManager.value,
                                                            reason: selectedAbsenceType,
                                                            registrationType: selectedRegistrationType,
                                                            validated: false,
                                                            teacherValidation: .pending,
                                                            isDoubleRegistrationActivated: isDoubleRegistrationActivated)
                                        
                                        if shouldUpdate {
                                            childrenManager.updateAbsenceReport(child: selectedChild, report: report) { result in
                                                if result {
                                                    self.selectedChild = nil
                                                    self.selectedName = ""
                                                    self.textBindingManager.value = ""
                                                    self.selectedAbsenceString = ""
                                                    self.isInterval = false
                                                    self.startDate = Date()
                                                    self.endDate = Date()
                                                    dismiss()
                                                } else {
                                                    isPresented.toggle()
                                                }
                                            }
                                        } else {
                                            childrenManager.createAbsenceReport(child: selectedChild, report: report) { result in
                                                if result {
                                                    self.selectedChild = nil
                                                    self.selectedName = ""
                                                    self.textBindingManager.value = ""
                                                    self.selectedAbsenceString = ""
                                                    self.isInterval = false
                                                    self.startDate = Date()
                                                    self.endDate = Date()
                                                } else {
                                                    isPresented.toggle()
                                                }
                                                if isAbsenceChange {
                                                    dismiss()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsBold, fontSize: Resources.FontSize.body))
                            .listRowBackground(Color.clear)
                            .accessibilityIdentifier("createRegistration")
                            .alert(isReportAlert ? "par_report_alert_title".localize : "parent_absence_registration_alert_title".localize, isPresented: $showingAlert, actions: {
                                Button("ok".localize, role: .cancel) { }
                            }, message: {
                                Text(isReportAlert ? "par_report_alert_text".localize : "parent_absence_registration_alert_description".localize)
                            })
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .environmentObject(schoolManager)
            .fullScreenCover(isPresented: $isPresented, content: {
                ErrorView(title: "alert_title".localize, error: "alert_default_description".localize)
            })
            .fullScreenCover(item: $errorHandling.appError, content: { appError in
                ErrorView(title: appError.title, error: appError.description) {
                    childrenManager.fetchChildren(parentID: DefaultsManager.shared.currentProfileID) { result in
                        if result {
                            childrenManager.attachAbsenceListeners()
                        }
                    }
                    childrenManager.attachReportListeners()
                }
            })
            .navigationTitle("parent_absence_registration_nav_title".localize)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension ParentAbsenceRegistrationView {
    
    // This function is checking if there already exist a report for the given date.
    private func checkReport() -> Bool {
        var alreadyExistReport: Bool = false
        
        childrenManager.reports.forEach { report in
            if report.studentID == selectedChild?.id && report.date.selectedDateFormatted == startDate.selectedDateFormatted {
                alreadyExistReport = true
            }
        }
        return alreadyExistReport
    }
}


struct ParentAbsenceRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        ParentAbsenceRegistrationView(report: nil, absence: nil, child: Student(name: "", className: "", email: "", classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: "", classID: ""), associatedSchool: "", cpr: ""), shouldUpdate: false, isAbsenceChange: false)
    }
}
