//
//  ClassListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 24/03/2022.
//

import SwiftUI

struct ClassListView: View {
    @ObservedObject var registrationManager = RegistrationManager()
    
    init() {
        // To make the List background transparent, so the gradient background can be used.
        UITableView.appearance().backgroundColor = .clear
        self.registrationManager.fetchClasses()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Resources.BackgroundGradient.backgroundGradient
                    .ignoresSafeArea()
                Form {
                    Section {
                        ForEach(registrationManager.classes, id: \.self) { className in
                            ClassEntity(className: className)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .navigationTitle("Klasse liste")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ClassEntity: View {
    let className: String
    
    var body: some View {
        NavigationLink(destination: StatisticsView(navigationTitle: className, isStudentPresented: false)) {
            HStack {
                Text(className)
                    .darkBodyTextStyle()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
        }
        .padding(.trailing, 20)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 1)
        )
        .padding(4)
    }
}

struct ClassListView_Previews: PreviewProvider {
    static var previews: some View {
        ClassListView()
    }
}
