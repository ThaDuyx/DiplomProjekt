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
            AbsenceInformationView(name: report.studentName, reason: report.reason, date: report.date, description: report.description ?? "")
            Spacer()
            VStack(spacing: 10) {
                Section(
                    header: HStack {
                        Image(systemName: "person.crop.circle.badge.questionmark")
                            .foregroundColor(Resources.Color.Colors.fiftyfifty)
                        Text("Vælg fravær - \(selectedAbsence)")
                            .boldDarkSmallBodyTextStyle()
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
                            .stroke(Resources.Color.Colors.frolyRed, lineWidth: 1)
                    )
                }
            }
            Spacer()
            HStack {
                Button("Afslå") {
                    reportManager.denyReport(selectedReport: report, teacherValidation: "Afslået") { result in
                        if result {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            context.present(ErrorView(error: "alert_default_description".localize))
                        }
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.DeclineButtonStyle())
                
                Spacer()
                
                Button("Registrer") {
                    reportManager.validateReport(selectedReport: report, validationReason: selectedAbsence, teacherValidation: "Godkendt") { result in
                        if result {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            context.present(ErrorView(error: "alert_default_description".localize))
                        }
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.RegisterButtonStyle())
            }
            .frame(width: 320)
            Spacer()
        }
        .fullScreenCover(context)
        .navigationTitle("Indberettelse af elev")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AbsenceInformationView: View {
    let name: String
    let reason: String
    let date: Date
    let description: String
    
    var body: some View {
        VStack {
            Text("Indberettelse")
                .boldBodyTextStyle()
            Divider()
                .frame(height: 1)
                .background(.white)
            AbsenceRow(title: "Elev", icon: "person", description: name)
            AbsenceRow(title: "Årsag", icon: "questionmark.circle", description: reason)
            AbsenceRow(title: "Dato", icon: "calendar", description: DateFormatter.abbreviationDayMonthYearFormatter.string(from: date))
            AbsenceRow(title: "Beskrivelse", icon: "note.text", description: description)
        }
        .frame(width: 320)
        .padding(.vertical, 20)
        .background(Resources.Color.Colors.frolyRed)
        .cornerRadius(20)
    }
}

struct AbsenceRow : View {
    let title: String
    let icon: String
    let description: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .boldSmallBodyTextStyle()
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Resources.Color.Colors.white)
                Text(description)
                    .smallBodyTextStyle()
                    .padding(4)
            }
            .padding(.leading, 10)
            .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Resources.Color.Colors.white, lineWidth: 1)
            )
        }
        .frame(width: 275)
    }
}

struct StudentReportView_Previews: PreviewProvider {
    static var previews: some View {
        StudentReportView(report: Report(id: "", parentName: "", parentID: "", studentName: "", studentID: "", className: "", date: Date(), endDate: Date(), description: "", reason: "", validated: false, teacherValidation: ""))
    }
}
