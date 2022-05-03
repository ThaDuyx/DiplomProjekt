//
//  ReportList.swift
//  Registr
//
//  Created by Christoffer Detlef on 18/04/2022.
//

import SwiftUI

struct ReportListView: View {
    @EnvironmentObject var childrenManager: ChildrenManager
    
    private var selectedStudent: String
    private var studentName: String
    private let student: Student
    
    init(selectedStudent: String, studentName: String, student: Student) {
        self.selectedStudent = selectedStudent
        self.studentName = studentName
        self.student = student
    }
    
    var body: some View {
        ZStack {
            List() {
                ForEach(TeacherValidation.allCases, id: \.rawValue) { validation in
                    Section(
                        header: Text(validation.rawValue)
                            .bigBodyTextStyle(color: .fiftyfifty, font: .poppinsMedium)
                    ) {
                        ForEach(childrenManager.reports, id: \.self) { report in
                            if report.studentID == selectedStudent && report.teacherValidation == validation {
                                ReportSection(report: report, student: student)
                                    .padding(.bottom, 20)
                            }
                        }
                        .listRowSeparator(.hidden)
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
        ReportListView(selectedStudent: "", studentName: "", student: Student(name: "", className: "", email: "", classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: ""), associatedSchool: ""))
    }
}
