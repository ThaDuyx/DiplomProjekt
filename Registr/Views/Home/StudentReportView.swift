//
//  StudentReportView.swift
//  Registr
//
//  Created by Christoffer Detlef on 13/04/2022.
//

import SwiftUI

struct StudentReportView: View {
    
    // State variables
    @State private var isPresented = false
    @StateObject var errorHandling = ErrorHandling()
    @EnvironmentObject var reportViewModel: ReportViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedAbsence: RegistrationType = .illness
    
    // Selector
    let report: Report
    
    init(report: Report) {
        self.report = report
        _selectedAbsence = State(initialValue: report.registrationType)
    }
    
    var body: some View {
        VStack {
            StudentAbsenceInformationSection(name: report.studentName + " - " + report.className, reason: report.reason.rawValue, date: report.date, description: report.description ?? "", timeOfDay: report.timeOfDay.rawValue, endDate: report.endDate )
            
            Spacer()
            
            if DefaultsManager.shared.userRole == .teacher {
                VStack(spacing: 10) {
                    Section(
                        header: HStack {
                            Image(systemName: "person.crop.circle.badge.questionmark")
                                .foregroundColor(.fiftyfifty)
                            
                            Text("sr_pick_absences".localize + " - \(selectedAbsence.rawValue)")
                                .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                        }
                            .frame(width: 320, alignment: .leading)
                    ) {
                        VStack {
                            Picker("sr_pick_absences".localize, selection: $selectedAbsence) {
                                ForEach(RegistrationType.allCases, id: \.self) {
                                    if !$0.rawValue.isEmpty{
                                        Text($0.rawValue)
                                    }
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                        .listRowBackground(Color.clear)
                        .frame(width: 320, height: 100)
                        .clipped()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.frolyRed, lineWidth: 1)
                        )
                    }
                }
            }
            
            Spacer()
            
            HStack {
                Button("sr_denied".localize) {
                    reportViewModel.denyReport(selectedReport: report, teacherValidation: .denied) { result in
                        if result {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            isPresented.toggle()
                        }
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.SmallTransparentButtonStyle())
                
                Spacer()
                
                Button("sr_register".localize) {
                    if report.endDate != nil {
                        reportViewModel.validateInterval(
                            selectedReport: report,
                            validationReason: DefaultsManager.shared.userRole == .headmaster ? .legal : selectedAbsence,
                            teacherValidation: .accepted
                        ) { result in
                            if result {
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                isPresented.toggle()
                            }
                        }
                    } else {
                        reportViewModel.validateReport(
                            selectedReport: report,
                            validationReason: DefaultsManager.shared.userRole == .headmaster ? .legal : selectedAbsence,
                            teacherValidation: .accepted
                        ) { result in
                            if result {
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                isPresented.toggle()
                            }
                        }
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.SmallFilledButtonStyle())
            }
            .frame(width: 320)
            Spacer()
        }
        .fullScreenCover(isPresented: $isPresented, content: {
            ErrorView(title: "alert_title".localize, error: "alert_default_description".localize) {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .fullScreenCover(item: $errorHandling.appError, content: { appError in
            ErrorView(title: appError.title, error: appError.description) {
                reportViewModel.attachReportListeners()
            }
        })
        .navigationTitle("sr_navigationtitle".localize)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StudentReportView_Previews: PreviewProvider {
    static var previews: some View {
        StudentReportView(report: Report(id: "", parentName: "", parentID: "", studentName: "", studentID: "", className: "", classID: "", date: Date(), endDate: Date(), timeOfDay: .morning, description: "", reason: .illness, registrationType: .notRegistered, validated: false, teacherValidation: .pending, isDoubleRegistrationActivated: false))
    }
}
