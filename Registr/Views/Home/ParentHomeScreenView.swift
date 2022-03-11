//
//  ParentHomeScreenView.swift
//  Registr
//
//  Created by Christoffer Detlef on 11/03/2022.
//

import SwiftUI

struct ParentHomeScreenView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Resources.BackgroundGradient.backgroundGradient
                    .ignoresSafeArea()
                Form {
                    ForEach((1...7), id: \.self) {_ in
                        Section {
                            CardStack(name: "Simon Andersen", className: "8.Y", email: "mail@email.dk")
                        }
                        .listRowBackground(Resources.Color.Colors.darkBlue)
                    }
                }
            }
            .navigationTitle("Dine børn")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CardStack: View {
    var name: String
    var className: String
    var email: String
    
    init(name: String, className: String, email: String) {
        // To make the background transparent, so the gradient background can be used.
        UITableView.appearance().backgroundColor = .clear
        self.name = name
        self.className = className
        self.email = email
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack(spacing: 40) {
                    HStack {
                        VStack {
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                        .frame(width: 90, height: 90)
                        .background(Resources.Color.Colors.mediumMint)
                        .cornerRadius(10)
                    }
                    .foregroundColor(Resources.Color.Colors.darkPurple)
                    .frame(alignment: .leading)
                    HStack {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text("parent_home_name")
                                    .boldLightBodyTextStyle()
                                Text(name)
                                    .lightBodyTextStyle()
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("parent_home_class")
                                    .boldLightBodyTextStyle()
                                Text(className)
                                    .lightBodyTextStyle()
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("parent_home_email")
                                    .boldLightBodyTextStyle()
                                Text(verbatim: email)
                                    .lightBodyTextStyle()
                            }
                        }
                    }
                    .foregroundColor(Resources.Color.Colors.lightMint)
                    .frame(alignment: .center)
                }
            }
        }
    }
}

struct ParentHomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ParentHomeScreenView()
    }
}
