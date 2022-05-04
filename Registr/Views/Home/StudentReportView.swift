//
//  StudentReportView.swift
//  Registr
//
//  Created by Christoffer Detlef on 13/04/2022.
//

import SwiftUI
import SwiftUIKit

struct StudentReportView: View {
    
    @StateObject private var context = FullScreenCoverContext()
    @StateObject var errorHandling = ErrorHandling()
    @EnvironmentObject var reportManager: ReportManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var selectedAbsence: RegistrationType = .illness
    private var absence = ["Syg", "Ulovligt", "For sent"]
    
    let report: Report
    
    init(report: Report) {
        self.report = report
    }
    
    var body: some View {
        VStack {
            StudentAbsenceInformationSection(name: report.studentName + " - " + report.className, reason: report.reason.rawValue, date: report.date, description: report.description ?? "", timeOfDay: report.timeOfDay.rawValue )
            
            Spacer()
           
            if DefaultsManager.shared.userRole == .teacher {
                VStack(spacing: 10) {
                    Section(
                        header: HStack {
                            Image(systemName: "person.crop.circle.badge.questionmark")
                                .foregroundColor(.fiftyfifty)
                            
                            Text("Vælg fravær - \(selectedAbsence.rawValue)")
                                .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                        }
                            .frame(width: 320, alignment: .leading)
                    ) {
                        VStack {
                            Picker("Vælg fravær", selection: $selectedAbsence) {
                                ForEach(absence, id: \.self) {
                                    Text($0)
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
                Button("Afslå") {
                    reportManager.denyReport(selectedReport: report, teacherValidation: .denied) { result in
                        if result {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            context.present(ErrorView(title: "alert_title".localize, error: "alert_default_description".localize) {
                                presentationMode.wrappedValue.dismiss()
                            })
                        }
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.SmallTransparentButtonStyle())
                
                Spacer()
                
                Button("Registrer") {
                    reportManager.validateReport(
                        selectedReport: report,
                        validationReason: DefaultsManager.shared.userRole == .headmaster ? .legal : selectedAbsence,
                        teacherValidation: .accepted
                    ) { result in
                        if result {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            context.present(ErrorView(title: "alert_title".localize, error: "alert_default_description".localize) {
                                presentationMode.wrappedValue.dismiss()
                            })
                        }
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.SmallFilledButtonStyle())
            }
            .frame(width: 320)
            Spacer()
        }
        .fullScreenCover(context)
        .fullScreenCover(item: $errorHandling.appError, content: { appError in
            ErrorView(title: appError.title, error: appError.description) {
                reportManager.attachReportListeners()
            }
        })
        .navigationTitle("Indberettelse af elev")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StudentReportView_Previews: PreviewProvider {
    static var previews: some View {
        StudentReportView(report: Report(id: "", parentName: "", parentID: "", studentName: "", studentID: "", className: "", date: Date(), endDate: Date(), timeOfDay: .morning, description: "", reason: .illness, registrationType: .notRegistered, validated: false, teacherValidation: .pending, isDoubleRegistrationActivated: false))
    }
}
