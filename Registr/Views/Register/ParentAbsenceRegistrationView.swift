//
//  ParentAbsenceRegistrationView.swift
//  Registr
//
//  Created by Christoffer Detlef on 31/03/2022.
//

import SwiftUI
import SwiftUIKit

enum AbsenceType: String, CaseIterable {    
    case sickness = "Sygdom"
    case late = "For Sent"
    case vacation = "Ferie"
    case prolongedIllness = "Forlænget sygdom"
}

struct ParentAbsenceRegistrationView: View {
    // Manager objects
    @StateObject private var context = FullScreenCoverContext()
    @EnvironmentObject var childrenManager: ChildrenManager
    @ObservedObject var textBindingManager = TextBindingManager(limit: 150)
    @Environment(\.dismiss) var dismiss
    
    // States variables
    @State private var selectedAbsence = ""
    @State private var selectedTime = ""
    @State private var selectedTimeOfDay: TimeOfDay = .morning
    @State private var selectedName = ""
    @State private var selectedChild: Student?
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isDoubleRegistrationActivated = false
    @State private var isInterval = false
    @State private var showsStartDatePicker = false
    @State private var showsEndDatePicker = false
    @State private var showingAlert = false
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
            _selectedAbsence = State(initialValue: availableReport.reason)
            _isDoubleRegistrationActivated = State(initialValue: availableReport.isDoubleRegistrationActivated)
            _selectedTimeOfDay = State(initialValue: availableReport.timeOfDay)
            _selectedTime = State(initialValue: availableReport.timeOfDay.rawValue)
            _startDate = State(initialValue: availableReport.date)
            
            if let availableEndDate = availableReport.endDate {
                _isInterval = State(initialValue: true)
                _showsEndDatePicker = State(initialValue: true)
                _endDate = State(initialValue: availableEndDate)
            }
            
            if let availableDescription = availableReport.description {
                textBindingManager.value = availableDescription
            }
        }
        
        if let availableAbsence = absence {
            _selectedAbsence = State(initialValue: availableAbsence.reason)
            _isDoubleRegistrationActivated = State(initialValue: false)
            _selectedTimeOfDay = State(initialValue: availableAbsence.isMorning ? .morning : .afternoon)
            _selectedTime = State(initialValue: availableAbsence.isMorning ? TimeOfDay.morning.rawValue : TimeOfDay.afternoon.rawValue)
            _startDate = State(initialValue: availableAbsence.date.dateFromString)
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
                                    selectedTimeOfDay = .morning
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
                                        selectedAbsence = absenceType.rawValue
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "questionmark")
                                        .foregroundColor(.white)
                                    Text(selectedAbsence.isEmpty ? "parent_absence_registration_pick_reason".localize : selectedAbsence)
                                        .bodyTextStyle(color: .white, font: .poppinsRegular)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .listRowBackground(Color.frolyRed)
                        
                        if isDoubleRegistrationActivated {
                            Section(
                                header:
                                    Text("parent_absence_registration_time")
                                    .bodyTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
                            ) {
                                Menu {
                                    ForEach(TimeOfDay.allCases, id: \.self) { timeType in
                                        Button(timeType.rawValue) {
                                            selectedTime = timeType.rawValue
                                            selectedTimeOfDay = timeType
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "clock")
                                            .foregroundColor(.white)
                                        Text(selectedTime.isEmpty ? "parent_absence_registration_pick_time".localize : selectedTime)
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
                                DatePicker(
                                    "",
                                    selection: $startDate,
                                    in: dateRange,
                                    displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .applyTextColor(Color.white)
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
                                    DatePicker(
                                        "",
                                        selection: $endDate,
                                        in: dateRange,
                                        displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .applyTextColor(.white)
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
                                }
                            }
                        }
                        .listRowBackground(Color.frolyRed)
                        
                        VStack(alignment: .center) {
                            Button(shouldUpdate ? "Opdater" : "parent_absence_registration_report".localize) {
                                if selectedName.isEmpty || selectedAbsence.isEmpty || isDoubleRegistrationActivated && selectedTime.isEmpty {
                                    showingAlert = true
                                } else {
                                    if let selectedChild = selectedChild, let name = UserManager.shared.user?.name, let id = selectedChild.id, !selectedAbsence.isEmpty {
                                        let report = Report(id: shouldUpdate ? report?.id : nil,
                                                            parentName: name,
                                                            parentID: DefaultsManager.shared.currentProfileID,
                                                            studentName: selectedChild.name,
                                                            studentID: id,
                                                            className: selectedChild.className,
                                                            date: startDate,
                                                            endDate: isInterval ? endDate : nil,
                                                            timeOfDay: isDoubleRegistrationActivated ? selectedTimeOfDay : .morning,
                                                            description: textBindingManager.value,
                                                            reason: selectedAbsence,
                                                            validated: false,
                                                            teacherValidation: "tv-pending".localize,
                                                            isDoubleRegistrationActivated: isDoubleRegistrationActivated)
                                        
                                        if shouldUpdate {
                                            childrenManager.updateAbsenceReport(child: selectedChild, report: report) { result in
                                                if result {
                                                    self.selectedChild = nil
                                                    self.selectedName = ""
                                                    self.textBindingManager.value = ""
                                                    self.selectedAbsence = ""
                                                    self.isInterval = false
                                                    self.startDate = Date()
                                                    self.endDate = Date()
                                                    dismiss()
                                                } else {
                                                    context.present(ErrorView(error: "alert_default_description".localize))
                                                }
                                            }
                                        } else {
                                            childrenManager.createAbsenceReport(child: selectedChild, report: report) { result in
                                                if result {
                                                    self.selectedChild = nil
                                                    self.selectedName = ""
                                                    self.textBindingManager.value = ""
                                                    self.selectedAbsence = ""
                                                    self.isInterval = false
                                                    self.startDate = Date()
                                                    self.endDate = Date()
                                                } else {
                                                    context.present(ErrorView(error: "alert_default_description".localize))
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
                            .alert("parent_absence_registration_alert_title".localize, isPresented: $showingAlert, actions: {
                                Button("ok".localize, role: .cancel) { }
                            }, message: {
                                Text("parent_absence_registration_alert_description".localize)
                            })
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .fullScreenCover(context)
            .navigationTitle("parent_absence_registration_nav_title".localize)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct ParentAbsenceRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        ParentAbsenceRegistrationView(report: nil, absence: nil, child: Student(name: "", className: "", email: "", classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: ""), associatedSchool: ""), shouldUpdate: false, isAbsenceChange: false)
    }
}
