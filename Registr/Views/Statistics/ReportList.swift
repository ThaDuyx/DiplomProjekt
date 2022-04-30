//
//  ReportList.swift
//  Registr
//
//  Created by Christoffer Detlef on 18/04/2022.
//

import SwiftUI

struct ReportList: View {
    @EnvironmentObject var childrenManager: ChildrenManager
    @State var showModal = false
    
    var selectedStudent: String
    var studentName: String
    
    init(selectedStudent: String, studentName: String) {
        self.selectedStudent = selectedStudent
        self.studentName = studentName
    }
    
    var body: some View {
        ZStack {
            List() {
                ForEach(childrenManager.reports, id: \.self) { report in
                    if report.studentID == selectedStudent {
                        ReportListRow(report: report)
                            .padding(.bottom, 20)
                            .sheet(isPresented: $showModal) {
                                ParentAbsenceRegistrationView()
                            }
                            .onTapGesture {
                                showModal = true
                            }
                    }
                }
            }
        }
        .navigationTitle(studentName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReportListRow: View {
    let report: Report
    
    var body: some View {
        HStack(spacing: 20) {
            
            Image(systemName: validationImage(report: report))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(Color.frolyRed)
                .clipShape(Circle())
            
            VStack {
                Text("Validering")
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)

                Text(report.teacherValidation)
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
                        
            Image(systemName: "ellipsis")
                .foregroundColor(Color.fiftyfifty)
                .padding(.trailing, 10)
        }
    }
}

private func validationImage(report: Report) -> String {
    let denied = "Afslået"
    
    if !report.validated && report.teacherValidation == denied {
        return "xmark.circle"
    } else if !report.validated && report.teacherValidation != denied {
        return "questionmark.circle"
    } else {
        return "checkmark.circle"
    }
}

struct ReportList_Previews: PreviewProvider {
    static var previews: some View {
        ReportList(selectedStudent: "", studentName: "")
    }
}
