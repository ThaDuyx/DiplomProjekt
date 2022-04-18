//
//  ReportListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 01/04/2022.
//

import SwiftUI

struct ReportListView: View {
    @EnvironmentObject var childrenManager: ChildrenManager
    
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
                }
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
                .padding()
                .background(Resources.Color.Colors.frolyRed)
                .clipShape(Circle())
            
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
            
            NavigationLink(destination: EmptyView()) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            
            Image(systemName: "chevron.right")
                .foregroundColor(Resources.Color.Colors.fiftyfifty)
                .padding(.trailing, 10)
        }
        .listRowBackground(Color.clear)
    }
}

struct ReportListView_Previews: PreviewProvider {
    static var previews: some View {
        ReportListView(selectedStudent: "", studentName: "")
    }
}
