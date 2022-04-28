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
                        ReportSectionView(absence: absence)
                            .padding(.bottom, 20)
                            .sheet(isPresented: $showModal) {
                                ParentAbsenceRegistrationView()
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

struct ReportSectionView: View {
    @EnvironmentObject var childrenManager: ChildrenManager
    
    let absence: Registration
    
    init(absence: Registration){
        self.absence = absence
    }
    
    var body: some View {
        HStack {
            Text(stringSeparator(reason: absence.reason).uppercased())
                .smallBodyTextStyle(color: .white, font: .poppinsBold)
                .frame(width: 36, height: 36)
                .background(Color.frolyRed)
                .clipShape(Circle())
            
            Spacer()
            
            VStack {
                Text("Dato")
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                Text(absence.date)
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
            }
            
            Spacer()
            
            VStack {
                Text("Årsag")
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                Text(absence.reason)
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
            }
            
            Spacer()

            Image(systemName: "ellipsis")
                .foregroundColor(Color.fiftyfifty)
                .padding(.trailing, 10)
        }
        .listRowBackground(Color.clear)
    }
}

struct AbsenceListView_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceListView(selectedStudent: "", studentName: "")
    }
}
