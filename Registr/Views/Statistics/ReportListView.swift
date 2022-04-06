//
//  ReportListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 01/04/2022.
//

import SwiftUI

struct ReportListView: View {
    
    init() {
        // To make the List background transparent, so the gradient background can be used.
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            List(0 ..< 5) { _ in
                ReportSectionView()
                    .padding(.bottom, 20)
            }
        }
        .navigationTitle("")
    }
}

struct ReportSectionView: View {
    var body: some View {
        NavigationLink(destination: EmptyView()) {
            HStack {
                Image("AbsenceImages/AbsenceLate")
                VStack {
                    Text("Dato")
                        .darkBoldBodyTextStyle()
                    Text("30-03-2021")
                        .darkBodyTextStyle()
                }
                Spacer()
                VStack {
                    Text("Årsag")
                        .darkBoldBodyTextStyle()
                    Text("")
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
        ReportListView()
    }
}
