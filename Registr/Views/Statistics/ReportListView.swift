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
    
    init(selectedStudent: String) {
        // To make the List background transparent, so the gradient background can be used.
        UITableView.appearance().backgroundColor = .clear
        self.selectedStudent = selectedStudent
    }
    
    var body: some View {
        ZStack {
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            List() {
                ForEach(childrenManager.absences, id: \.self) { absence in
                    ReportSectionView(absence: absence)
                        .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("")
        .onAppear(){
            childrenManager.fetchChildrenAbsence(studentID: selectedStudent)
            childrenManager.fetchChildrenReports(childID: selectedStudent)
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
        NavigationLink(destination: EmptyView()) {
            HStack {
                Image("AbsenceImages/AbsenceLate")
                VStack {
                    Text("Dato")
                        .darkBoldBodyTextStyle()
                    Text(absence.date)
                        .darkBodyTextStyle()
                }
                Spacer()
                VStack {
                    Text("Årsag")
                        .darkBoldBodyTextStyle()
                    Text(absence.reason)
                        .darkBodyTextStyle()
                }
                Spacer()
                VStack {
                    Text("Registreret")
                        .darkBoldBodyTextStyle()
                    Text("Ulovligt")
                        .darkBodyTextStyle()
                }
            }
        }
        .listRowBackground(Color.clear)
    }
}

struct ReportListView_Previews: PreviewProvider {
    static var previews: some View {
        ReportListView(selectedStudent: "")
    }
}
