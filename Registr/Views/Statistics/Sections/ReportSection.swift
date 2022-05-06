//
//  ReportSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import SwiftUI

struct ReportSection: View {
    @EnvironmentObject var childrenManager: ChildrenManager
    @StateObject var errorHandling = ErrorHandling()
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
                    
                    if let endDate = report.endDate {
                        let lastDate = endDate.selectedDateFormatted
                        let firstDate = report.date.selectedDateFormatted
                        let dateCombined = firstDate + "\n" + lastDate
                        Text(dateCombined)
                            .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
                    } else {
                        Text(report.date.formatSpecificDate(date: report.date))
                            .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
                    }
                }
                
                VStack {
                    Text("Årsag")
                        .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                    
                    Text(report.reason.rawValue)
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
            .fullScreenCover(item: $errorHandling.appError, content: { appError in
                ErrorView(title: appError.title, error: appError.description) {
                    if appError.type == .childrenManagerDeleteError {
                        childrenManager.deleteReport(report: report, child: student)
                    } else {
                        childrenManager.fetchChildren(parentID: DefaultsManager.shared.currentProfileID) { result in
                            if result {
                                childrenManager.attachAbsenceListeners()
                            }
                        }
                        childrenManager.attachReportListeners()
                    }
                }
            })
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
        ReportSection(report: Report(id: "", parentName: "", parentID: "", studentName: "", studentID: "", className: "", classID: "", date: Date(), endDate: Date(), timeOfDay: .morning, description: "", reason: .late, registrationType: .notRegistered, validated: false, teacherValidation: .pending, isDoubleRegistrationActivated: false), student: Student(name: "", className: "", email: "", classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: "", classID: ""), associatedSchool: ""))
    }
}
