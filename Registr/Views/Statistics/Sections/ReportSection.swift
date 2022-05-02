//
//  ReportSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import SwiftUI

struct ReportSection: View {
    @EnvironmentObject var childrenManager: ChildrenManager
    @State var showModal = false
    let report: Report
    let student: Student
    
    var body: some View {
        Menu {
            Button("Rediger") {
                showModal = true
            }
            
            Button("Slet") {
                childrenManager.deleteReport(report: report, child: student)
            }
        } label: {
            HStack(spacing: 20) {
                
                Image(systemName: validationImage(report: report))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.frolyRed)
                    .clipShape(Circle())
                
                VStack {
                    Text("Validering")
                        .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                    
                    Text(report.teacherValidation.rawValue)
                        .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
                }
                
                VStack {
                    Text("Dato")
                        .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                    
                    Text(report.date.formatSpecificDate(date: report.date))
                        .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
                }
                
                VStack {
                    Text("Årsag")
                        .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                    
                    Text(report.reason)
                        .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
                }
                
                if report.teacherValidation == .pending {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.fiftyfifty)
                        .padding(.trailing, 10)
                }
            }
            .sheet(isPresented: $showModal) {
                ParentAbsenceRegistrationView(report: report, absence: nil, child: student, shouldUpdate: true, isAbsenceChange: false)
            }
        }
        .disabled(report.teacherValidation != .pending)
    }
    
    private func validationImage(report: Report) -> String {
        if report.teacherValidation == .denied {
            return "xmark.circle"
        } else if report.teacherValidation == .accepted {
            return "checkmark.circle"
        } else {
            return "questionmark.circle"
        }
    }
}

struct ReportSection_Previews: PreviewProvider {
    static var previews: some View {
        ReportSection(report: Report(id: "", parentName: "", parentID: "", studentName: "", studentID: "", className: "", date: Date(), endDate: Date(), timeOfDay: .morning, description: "", reason: "", validated: false, teacherValidation: .pending, isDoubleRegistrationActivated: false), student: Student(name: "", className: "", email: "", classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: ""), associatedSchool: ""))
    }
}
