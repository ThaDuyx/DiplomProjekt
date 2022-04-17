//
 //  RegisterView.swift
 //  Registr
 //
 //  Created by Christoffer Detlef on 10/03/2022.
 //

 import SwiftUI

 struct RegisterView: View {

     @EnvironmentObject var registrationManager: RegistrationManager
     @State var favorites = DefaultsManager.shared.favorites

     init() {
         // To make the List background transparent, so the gradient background can be used.
         UITableView.appearance().backgroundColor = .clear
     }

     var body: some View {
         NavigationView {
             ZStack {
                 Resources.BackgroundGradient.backgroundGradient
                     .ignoresSafeArea()
                 Form() {
                     // Favorite section
                     Section(
                         header:
                             HStack {
                                 Image(systemName: "star")
                                 Text("register_section_header_favoritter")
                             }
                     ) {
                         ForEach(registrationManager.classes, id: \.self) { className in
                             if favorites.contains(className) {
                                 ClassStack(className: className, isFavorite: true)
                             }
                         }
                     }
                     .listRowSeparator(.hidden)
                     .listRowBackground(Color.clear)
                     .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

                     // Other classes section
                     Section(
                         header:
                             HStack {
                                 Image(systemName: "person.3")
                                 Text("register_section_header_classes")
                             }
                     ) {
                         ForEach(registrationManager.classes, id: \.self) { className in
                             if !favorites.contains(className) {
                                 ClassStack(className: className)
                             }
                         }
                     }
                     .listRowSeparator(.hidden)
                     .listRowBackground(Color.clear)
                     .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                 }
             }
             .navigationTitle("Registrer")
             .navigationBarTitleDisplayMode(.inline)
         }
     }
 }

 struct ClassStack: View {
     let className: String
     var isFavorite: Bool = false
     @EnvironmentObject var registrationManager: RegistrationManager

     var body: some View {
         NavigationLink(destination: StudentClassListView(selectedClass: className)) {
             VStack {
                 ZStack {
                     HStack {
                         Image(systemName: isFavorite ? "star.fill" : "star")
                             .frame(alignment: .leading)
                             .foregroundColor(Resources.Color.Colors.darkBlue)
                         Spacer()
                     }
                     Spacer()
                     HStack {
                         Text(className)
                             .frame(alignment: .center)
                     }
                     .padding(.leading, 20)
                 }
                 .padding()
             }
         }
         .environmentObject(registrationManager)
         .padding(.trailing, 20)
         .overlay(
             RoundedRectangle(cornerRadius: 5)
                 .stroke(Color.black, lineWidth: 1)
         )
         .padding(4)
     }
 }

 struct RegisterView_Previews: PreviewProvider {
     static var previews: some View {
         RegisterView()
     }
 }
