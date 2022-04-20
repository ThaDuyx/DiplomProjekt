//
//  ParentAbsenceRegistrationView.swift
//  Registr
//
//  Created by Christoffer Detlef on 31/03/2022.
//

import SwiftUI

enum AbsenceType: String, CaseIterable {    
    case sickness = "Sygdom"
    case late = "For Sent"
    case vacation = "Ferie"
    case prolongedIllness = "Forlænget sygdom"
}

struct ParentAbsenceRegistrationView: View {
    @EnvironmentObject var childrenManager: ChildrenManager
    @ObservedObject var textBindingManager = TextBindingManager(limit: 150)
    
    @State private var selectedAbsence = ""
    @State private var selectedName = ""
    @State private var selectedChild: Student?
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isInterval = false
    @State var showsStartDatePicker = false
    @State var showsEndDatePicker = false
    @State var showPlaceholderText = false
    @State private var placeholderDescription: String = "Skriv beskrivelse"
    
    // For dismissing the keyboard
    enum Field: Hashable {
        case myField
    }
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ZStack {
            Form {
                Section(
                    header: Text("Barn")
                ) {
                    Menu {
                        ForEach(childrenManager.children, id: \.self) { child in
                            Button(child.name + " - " + child.className) {
                                selectedName = child.name
                                selectedChild = child
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(Resources.Color.Colors.lightMint)
                            Text(selectedName.isEmpty ? "Vælg barn" : selectedName)
                                .lightBodyTextStyle()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.down")
                                .foregroundColor(Resources.Color.Colors.lightMint)
                        }
                    }
                }
                .listRowBackground(Resources.Color.Colors.fiftyfifty)
                
                Section(
                    header: Text("Fraværs årsag")
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
                                .foregroundColor(Resources.Color.Colors.lightMint)
                            Text(selectedAbsence.isEmpty ? "Vælg fraværsårsag" : selectedAbsence)
                                .lightBodyTextStyle()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.down")
                                .foregroundColor(Resources.Color.Colors.lightMint)
                        }
                    }
                }
                .listRowBackground(Resources.Color.Colors.fiftyfifty)
                
                Section(
                    header: Text("Interval")
                ) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Resources.Color.Colors.lightMint)
                        Toggle("Aktivér for slutdato", isOn: $isInterval)
                            .lightBodyTextStyleToggle()
                            .toggleStyle(SwitchToggleStyle(tint: Resources.Color.Colors.mediumMint))
                    }
                }
                .listRowBackground(Resources.Color.Colors.fiftyfifty)
                
                Section(
                    header: Text("Startdato")
                ) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Resources.Color.Colors.lightMint)
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
                        .applyTextColor(Resources.Color.Colors.lightMint)
                    }
                }
                .listRowBackground(Resources.Color.Colors.fiftyfifty)
                
                if isInterval {
                    Section(
                        header: Text("Slutdato")
                    ) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Resources.Color.Colors.lightMint)
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
                            .applyTextColor(Resources.Color.Colors.lightMint)
                        }
                    }
                    .listRowBackground(Resources.Color.Colors.fiftyfifty)
                }
                
                Section(
                    header:
                        Text("student_absence_description").darkBlueBodyTextStyle()
                ) {
                    HStack {
                        Image(systemName: "note.text")
                            .foregroundColor(Resources.Color.Colors.lightMint)
                        ZStack(alignment: .leading) {
                            if textBindingManager.value.isEmpty && !showPlaceholderText {
                                Text("Skriv beskrivelse")
                                    .lightBodyTextStyle()
                            }
                            TextEditor(text: $textBindingManager.value)
                                .lightBodyTextStyleTextEditor()
                                .focused($focusedField, equals: .myField)
                                .onTapGesture {
                                    if (focusedField != nil) {
                                        focusedField = nil
                                    }
                                }
                        }
                        .onTapGesture {
                            showPlaceholderText = true
                        }
                    }
                }
                .listRowBackground(Resources.Color.Colors.fiftyfifty)
                
                Button("Indberet") {
                    if let selectedChild = selectedChild, let name = UserManager.shared.user?.name, let id = selectedChild.id, !selectedAbsence.isEmpty {
                        let report = Report(parentName: name, parentID: DefaultsManager.shared.currentProfileID, studentName: selectedChild.name, studentID: id, className: selectedChild.className, date: startDate, endDate: isInterval ? endDate : nil, description: textBindingManager.value, reason: selectedAbsence, validated: false, teacherValidation: "Afventer")
                        
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
                                // TODO: ErrorView shown and maybe animation or something
                            }
                        }
                    }
                    else {
                        // TODO: ErrorView shown with 'Select a child'
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.RegisterButtonStyle())
                .padding(.leading, 200)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Indberettelse af elev")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct ParentAbsenceRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        ParentAbsenceRegistrationView()
    }
}
