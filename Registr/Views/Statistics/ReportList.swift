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
        .navigationTitle(studentName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            childrenManager.fetchChildrenReports(childID: selectedStudent)
        }
    }
}

struct ReportListRow: View {
    let report: Report
    
    var body: some View {
        HStack(spacing: 20) {
            
            Image(systemName: validationImage(report: report))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(Resources.Color.Colors.frolyRed)
                .clipShape(Circle())
            
            VStack {
                Text("Validering")
                    .boldDarkSmallBodyTextStyle()
                
                Text(report.teacherValidation)
                    .smallDarkBodyTextStyle()
            }
            
            VStack {
                Text("Dato")
                    .boldDarkSmallBodyTextStyle()
                
                Text(report.date.formatSpecificData(date: report.date))
                    .smallDarkBodyTextStyle()
            }
            
            VStack {
                Text("Årsag")
                    .boldDarkSmallBodyTextStyle()
                
                Text(report.reason)
                    .smallDarkBodyTextStyle()
            }
                        
            Image(systemName: "ellipsis")
                .foregroundColor(Resources.Color.Colors.fiftyfifty)
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
