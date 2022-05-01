//
//  ReportList.swift
//  Registr
//
//  Created by Christoffer Detlef on 18/04/2022.
//

import SwiftUI

struct ReportListView: View {
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
                        ReportSection(report: report)
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

struct ReportList_Previews: PreviewProvider {
    static var previews: some View {
        ReportListView(selectedStudent: "", studentName: "")
    }
}
