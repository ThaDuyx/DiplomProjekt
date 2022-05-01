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
    @EnvironmentObject var reportManager: ReportManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var selectedAbsence = "Syg"
    private var absence = ["Syg", "Ulovligt", "For sent"]
    
    let report: Report
    
    init(report: Report) {
        self.report = report
    }
    
    var body: some View {
        VStack {
            StudentAbsenceInformationSection(name: report.studentName, reason: report.reason, date: report.date, description: report.description ?? "", timeOfDay: report.timeOfDay.rawValue )
            Spacer()
            VStack(spacing: 10) {
                Section(
                    header: HStack {
                        Image(systemName: "person.crop.circle.badge.questionmark")
                            .foregroundColor(Color.fiftyfifty)
                        Text("Vælg fravær - \(selectedAbsence)")
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
            
            Spacer()
            
            HStack {
                Button("Afslå") {
                    reportManager.denyReport(selectedReport: report, teacherValidation: .denied) { result in
                        if result {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            context.present(ErrorView(error: "alert_default_description".localize))
                        }
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.SmallTransparentButtonStyle())
                
                Spacer()
                
                Button("Registrer") {
                    reportManager.validateReport(selectedReport: report, validationReason: selectedAbsence, teacherValidation: .accepted) { result in
                        if result {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            context.present(ErrorView(error: "alert_default_description".localize))
                        }
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.SmallFilledButtonStyle())
            }
            .frame(width: 320)
            Spacer()
        }
        .fullScreenCover(context)
        .navigationTitle("Indberettelse af elev")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StudentReportView_Previews: PreviewProvider {
    static var previews: some View {
        StudentReportView(report: Report(id: "", parentName: "", parentID: "", studentName: "", studentID: "", className: "", date: Date(), endDate: Date(), timeOfDay: .morning, description: "", reason: "", validated: false, teacherValidation: .pending, isDoubleRegistrationActivated: false))
    }
}
