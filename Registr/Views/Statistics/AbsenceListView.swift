//
//  AbsenceListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 01/04/2022.
//

import SwiftUI

struct AbsenceListView: View {
    @EnvironmentObject var childrenManager: ChildrenManager
    @StateObject var errorHandling = ErrorHandling()
    @State var showModal = false
    
    var selectedStudent: String
    var studentName: String
    let student: Student
    
    init(selectedStudent: String, studentName: String, student: Student) {
        self.selectedStudent = selectedStudent
        self.studentName = studentName
        self.student = student
    }
    
    var body: some View {
        ZStack {
            List() {
                ForEach(childrenManager.absences, id: \.self) { absence in
                    if absence.studentID == selectedStudent {
                        AbsenceReportSection(absence: absence)
                            .padding(.bottom, 20)
                            .sheet(isPresented: $showModal) {
                                ParentAbsenceRegistrationView(report: nil, absence: absence, child: student, shouldUpdate: false, isAbsenceChange: true)
                            }
                            .onTapGesture {
                                showModal = true
                            }
                    }
                }
                .listRowSeparatorTint(Color.fiftyfifty)
            }
        }
        .fullScreenCover(item: $errorHandling.appError, content: { appError in
            ErrorView(title: appError.title, error: appError.description) {
                childrenManager.fetchChildren(parentID: DefaultsManager.shared.currentProfileID) { result in
                    if result {
                        childrenManager.attachAbsenceListeners()
                    }
                }
                childrenManager.attachReportListeners()
            }
        })
        .navigationTitle(studentName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AbsenceListView_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceListView(selectedStudent: "", studentName: "", student: Student(name: "", className: "", email: "", classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: ""), associatedSchool: ""))
    }
}
