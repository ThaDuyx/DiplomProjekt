//
//  TeacherHomeScreenView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI

struct TeacherHomeScreenView: View {
    
    // To make the List background transparent, so the gradient background can be used.
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Resources.BackgroundGradient.backgroundGradient
                    .ignoresSafeArea()
                List {
                    Section(
                        header: Text("Placeholder text - Class")
                            .boldSubTitleTextStyle()
                    ) {
                        TaskRow()
                        TaskRow()
                        TaskRow()
                    }
                    .listRowBackground(Color.clear)
                    
                    Section(
                        header: Text("Placeholder text - Class")
                            .boldSubTitleTextStyle()
                    ){
                        TaskRow()
                        TaskRow()
                        TaskRow()
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Inberettelser")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TaskRow: View {
    var body: some View {
        NavigationLink(destination: StudentAbsenceView()) {
            Text("Placeholder text - Student name")
                .subTitleTextStyle()
                .lineLimit(1)
        }
    }
}

struct TeacherHomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherHomeScreenView()
    }
}
