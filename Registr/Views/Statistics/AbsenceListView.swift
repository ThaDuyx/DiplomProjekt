//
//  AbsenceListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 01/04/2022.
//

import SwiftUI

struct AbsenceListView: View {
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
                ForEach(childrenManager.absences, id: \.self) { absence in
                    if absence.studentID == selectedStudent {
                        AbsenceReportSection(absence: absence)
                            .padding(.bottom, 20)
                            .sheet(isPresented: $showModal) {
                                ParentAbsenceRegistrationView(report: nil, child: nil, shouldUpdate: false)
                            }
                            .onTapGesture {
                                showModal = true
                            }
                    }
                }
                .listRowSeparatorTint(Color.fiftyfifty)
            }
        }
        .navigationTitle(studentName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AbsenceListView_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceListView(selectedStudent: "", studentName: "")
    }
}
