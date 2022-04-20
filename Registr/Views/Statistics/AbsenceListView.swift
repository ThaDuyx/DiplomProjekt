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
                    ReportSectionView(absence: absence)
                        .padding(.bottom, 20)
                        .sheet(isPresented: $showModal) {
                            ParentAbsenceRegistrationView()
                        }
                        .onTapGesture {
                            showModal = true
                        }
                }
                .listRowSeparatorTint(Resources.Color.Colors.fiftyfifty)
            }
        }
        .navigationTitle(studentName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            childrenManager.fetchChildrenAbsence(studentID: selectedStudent)
        }
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
                .boldSmallBodyTextStyle()
                .frame(width: 36, height: 36)
                .background(Resources.Color.Colors.frolyRed)
                .clipShape(Circle())
            
            Spacer()
            
            VStack {
                Text("Dato")
                    .boldDarkSmallBodyTextStyle()
                Text(absence.date)
                    .smallDarkBodyTextStyle()
            }
            
            Spacer()
            
            VStack {
                Text("Årsag")
                    .boldDarkSmallBodyTextStyle()
                Text(absence.reason)
                    .smallDarkBodyTextStyle()
            }
            
            Spacer()

            Image(systemName: "ellipsis")
                .foregroundColor(Resources.Color.Colors.fiftyfifty)
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
