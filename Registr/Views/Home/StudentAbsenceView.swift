//
//  StudentAbsenceView.swift
//  Registr
//
//  Created by Christoffer Detlef on 16/03/2022.
//

import SwiftUI

struct StudentAbsenceView: View {
    
    private var absence = ["Fravær", "Ulovligt", "Forsent"]
    @State private var selectedAbsence = "Fravær"
    
    // To make the List background transparent, so the gradient background can be used.
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            List {
                Section(
                    header:
                        Text("student_absence_name").darkBlueBodyTextStyle()
                ) {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(Resources.Color.Colors.lightMint)
                        Text("Placeholder text - displays name")
                            .lightBodyTextStyle()
                    }
                }
                .listRowBackground(Resources.Color.Colors.darkBlue)
                Section(
                    header:
                        Text("student_absence_reason").darkBlueBodyTextStyle()
                        
                ) {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(Resources.Color.Colors.lightMint)
                        Text("Placeholder text - displays reason")
                            .lightBodyTextStyle()
                    }
                }
                .listRowBackground(Resources.Color.Colors.darkBlue)
                Section(
                    header:
                        Text("student_absence_date").darkBlueBodyTextStyle()
                ) {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(Resources.Color.Colors.lightMint)
                        Text("Placeholder text - displays date")
                            .lightBodyTextStyle()
                    }
                }
                .listRowBackground(Resources.Color.Colors.darkBlue)
                Section(
                    header:
                        Text("student_absence_description").darkBlueBodyTextStyle()
                ) {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(Resources.Color.Colors.lightMint)
                        Text("Placeholder text - limit to 3 lines")
                            .lightBodyTextStyle()
                            .lineLimit(3)
                    }
                }
                .listRowBackground(Resources.Color.Colors.darkBlue)
                Section {
                    NavigationLink(destination: ParentHomeScreenView()) {
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(Resources.Color.Colors.darkPurple)
                            Text("Fravær status")
                                .darkBodyTextStyle()
                        }
                    }
                }
                .listRowBackground(Color.clear)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 1)
                )

                Section(header: Text("Vælg fravær - \(selectedAbsence)")) {
                    VStack {
                        Picker("Vælg fravær", selection: $selectedAbsence) {
                            ForEach(absence, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .listRowBackground(Color.clear)
                    .frame(height: 130)
                    .clipped()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 1)
                    )
                }
                HStack {
                    Button("Registrer") {
                        print("Registrer")
                    }
                    .buttonStyle(Resources.CustomButtonStyle.RegisterButtonStyle())
                    Spacer()
                    Button("Afslå") {
                        print("Afslået")
                    }
                    .buttonStyle(Resources.CustomButtonStyle.DeclineButtonStyle())
                }
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Indberettelse af elev")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StudentAbsenceView_Previews: PreviewProvider {
    static var previews: some View {
        StudentAbsenceView()
            
    }
}
