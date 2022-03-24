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
        // Used to fetching the classes
        self.registrationManager.fetchClasses()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Resources.BackgroundGradient.backgroundGradient
                    .ignoresSafeArea()
                Form {
                    Section {
                        VStack {
                            ForEach(0..<registrationManager.classes.count, id: \.self) { index in
                                ClassEntity(className: registrationManager.classes[index])
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Klasse liste")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ClassEntity: View {
    var className: String
    
    init(className: String) {
        self.className = className
    }
    var body: some View {
        NavigationLink(destination: StatisticsView()) {
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
