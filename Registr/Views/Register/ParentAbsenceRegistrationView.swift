//
//  ParentAbsenceRegistrationView.swift
//  Registr
//
//  Created by Christoffer Detlef on 31/03/2022.
//

import SwiftUI
import SwiftUIKit

enum TimeOfDay: String, CaseIterable {
    case morning = "Morgen"
    case afternoon = "Eftermiddag"
    case allDay = "Hele Dagen"
}

enum AbsenceType: String, CaseIterable {    
    case sickness = "Sygdom"
    case late = "For Sent"
    case vacation = "Ferie"
    case prolongedIllness = "Forlænget sygdom"
}

struct ParentAbsenceRegistrationView: View {
    @StateObject private var context = FullScreenCoverContext()
    @EnvironmentObject var childrenManager: ChildrenManager
    @ObservedObject var textBindingManager = TextBindingManager(limit: 150)
    
    @State private var selectedAbsence = ""
    @State private var selectedTimeOfDay = ""
    @State private var selectedName = ""
    @State private var selectedChild: Student?
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isDoubleRegistrationActivated = false
    @State private var isInterval = false
    @State var showsStartDatePicker = false
    @State var showsEndDatePicker = false
    @State private var showingAlert = false
    
    // For dismissing the keyboard
    enum Field: Hashable {
        case myField
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ZStack {
            Form {
                Section(
                    header:
                        Text("Barn")
                        .bodyTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
                ) {
                    Menu {
                        ForEach(childrenManager.children, id: \.self) { child in
                            Button(child.name + " - " + child.className) {
                                selectedName = child.name
                                selectedChild = child
                                isDoubleRegistrationActivated = child.classInfo.isDoubleRegistrationActivated
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(Color.white)
                            Text(selectedName.isEmpty ? "Vælg barn" : selectedName)
                                .bodyTextStyle(color: Color.white, font: .poppinsRegular)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color.white)
                        }
                    }
                }
                .listRowBackground(Color.frolyRed)
                
                if selectedChild != nil {
                    Section(
                        header:
                            Text("Fraværs årsag")
                            .darkBodyTextStyle()
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
                                    .foregroundColor(Resources.Color.Colors.white)
                                Text(selectedAbsence.isEmpty ? "Vælg fraværsårsag" : selectedAbsence)
                                    .lightBodyTextStyle()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Resources.Color.Colors.white)
                            }
                        }
                    }
                    .listRowBackground(Resources.Color.Colors.frolyRed)
                    
                    if isDoubleRegistrationActivated {
                        Section(
                            header:
                                Text("Tidspunkt")
                                .darkBodyTextStyle()
                        ) {
                            Menu {
                                ForEach(TimeOfDay.allCases, id: \.self) { timeType in
                                    Button(timeType.rawValue) {
                                        selectedTimeOfDay = timeType.rawValue
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(Resources.Color.Colors.white)
                                    Text(selectedTimeOfDay.isEmpty ? "Vælg tidspunkt" : selectedTimeOfDay)
                                        .lightBodyTextStyle()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Resources.Color.Colors.white)
                                }
                            }
                        }
                        .listRowBackground(Resources.Color.Colors.frolyRed)
                    }
                    
                    Section(
                        header:
                            Text("Interval")
                            .darkBodyTextStyle()
                    ) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Resources.Color.Colors.white)
                            Toggle("Aktivér for slutdato", isOn: $isInterval)
                                .lightBodyTextStyleToggle()
                                .toggleStyle(SwitchToggleStyle(tint: Resources.Color.Colors.white.opacity(0.5)))
                        }
                    }
                    .listRowBackground(Resources.Color.Colors.frolyRed)
                    
                    Section(
                        header:
                            Text("Startdato")
                            .darkBodyTextStyle()
                    ) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Resources.Color.Colors.white)
                            Text(DateFormatter.abbreviationDayMonthYearFormatter.string(from: startDate))
                                .lightBodyTextStyle()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture {
                                    self.showsStartDatePicker.toggle()
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
                    .listRowBackground(Resources.Color.Colors.frolyRed)
                    
                    if isInterval {
                        Section(
                            header:
                                Text("Slutdato")
                                .darkBodyTextStyle()
                        ) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(Resources.Color.Colors.white)
                                Text(DateFormatter.abbreviationDayMonthYearFormatter.string(from: endDate))
                                    .lightBodyTextStyle()
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
                                .applyTextColor(Resources.Color.Colors.white)
                            }
                        }
                        .listRowBackground(Resources.Color.Colors.frolyRed)
                    }
                    
                    Section(
                        header:
                            Text("student_absence_description")
                            .darkBodyTextStyle()
                    ) {
                        HStack {
                            Image(systemName: "note.text")
                                .foregroundColor(Resources.Color.Colors.white)
                            ZStack(alignment: .leading) {
                                TextEditor(text: $textBindingManager.value)
                                    .lightBodyTextStyleTextEditor()
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
                    .listRowBackground(Resources.Color.Colors.frolyRed)
                    
                    VStack(alignment: .center) {
                        Button("Indberet") {
                            if selectedName.isEmpty || selectedAbsence.isEmpty || isDoubleRegistrationActivated && selectedTimeOfDay.isEmpty {
                                showingAlert = true
                            } else {
                                if let selectedChild = selectedChild, let name = UserManager.shared.user?.name, let id = selectedChild.id, !selectedAbsence.isEmpty {
                                    let report = Report(parentName: name,
                                                        parentID: DefaultsManager.shared.currentProfileID,
                                                        studentName: selectedChild.name,
                                                        studentID: id,
                                                        className: selectedChild.className,
                                                        date: startDate,
                                                        endDate: isInterval ? endDate : nil,
                                                        timeOfDay: isDoubleRegistrationActivated ? selectedTimeOfDay : "Morgen",
                                                        description: textBindingManager.value,
                                                        reason: selectedAbsence,
                                                        validated: false,
                                                        teacherValidation: "Afventer",
                                                        isDoubleRegistrationActivated: isDoubleRegistrationActivated)
                                    
                                    childrenManager.createAbsenceReport(child: selectedChild, report: report) { result in
                                        if result {
                                            // TODO: Show that the report has been written and reset everything
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
                                    }
                                }
                            }
                        }
                        .buttonStyle(Resources.CustomButtonStyle.FilledBodyTextButtonStyle())
                        .listRowBackground(Color.clear)
                        .alert("student_absence_alert_title".localize, isPresented: $showingAlert, actions: {
                            Button("OK", role: .cancel) { }
                        }, message: {
                            Text("student_absence_alert_description".localize)
                        })
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .fullScreenCover(context)
        .navigationTitle("Indberettelse af elev")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct ParentAbsenceRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        ParentAbsenceRegistrationView()
    }
}
