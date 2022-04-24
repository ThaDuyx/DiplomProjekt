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
    @StateObject private var context = FullScreenCoverContext()
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
                
                Section(
                    header:
                        Text("Fraværs årsag")
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
                                .foregroundColor(Color.white)
                            Text(selectedAbsence.isEmpty ? "Vælg fraværsårsag" : selectedAbsence)
                                .bodyTextStyle(color: Color.white, font: .poppinsRegular)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color.white)
                        }
                    }
                }
                .listRowBackground(Color.frolyRed)
                
                Section(
                    header:
                        Text("Interval")
                        .bodyTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
                ) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Color.white)
                        Toggle("Aktivér for slutdato", isOn: $isInterval)
                            .textStyleToggle(color: .white, font: .poppinsRegular, size: Resources.FontSize.body)
                            .toggleStyle(SwitchToggleStyle(tint: Color.white.opacity(0.5)))
                    }
                }
                .listRowBackground(Color.frolyRed)
                
                Section(
                    header:
                        Text("Startdato")
                        .bodyTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
                ) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Color.white)
                        Text(DateFormatter.abbreviationDayMonthYearFormatter.string(from: startDate))
                            .bodyTextStyle(color: Color.white, font: .poppinsRegular)
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
                .listRowBackground(Color.frolyRed)
                
                if isInterval {
                    Section(
                        header:
                            Text("Slutdato")
                            .bodyTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
                    ) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Color.white)
                            Text(DateFormatter.abbreviationDayMonthYearFormatter.string(from: endDate))
                                .bodyTextStyle(color: Color.white, font: .poppinsRegular)
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
                            .applyTextColor(Color.white)
                        }
                    }
                    .listRowBackground(Color.frolyRed)
                }
                
                Section(
                    header:
                        Text("student_absence_description")
                        .bodyTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
                ) {
                    HStack {
                        Image(systemName: "note.text")
                            .foregroundColor(Color.white)
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
                    Button("Indberet") {
                        if selectedName.isEmpty || selectedAbsence.isEmpty {
                            showingAlert = true
                        } else {
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
                                        context.present(ErrorView(error: "alert_default_description".localize))
                                    }
                                }
                            }
                        }
                    }
                    .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsBold, fontSize: Resources.FontSize.body))
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
