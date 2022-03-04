//
//  LoginPassword.swift
//  Registr
//
//  Created by Christoffer Detlef on 03/03/2022.
//

import SwiftUI

struct LoginPassword: View {
    @State private var userID: String = ""
    var body: some View {
        ZStack {
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 60) {
                    ZStack {
                        Text("application_name")
                            .titleTextStyle()
                    }
                    VStack(spacing: 10) {
                        Text("password")
                            .primaryHeaderTextStyle()
                            .frame(width: 280, alignment: .leading)
                        TextField("Indtast dit kodeord", text: $userID)
                            .frame(width: 265, height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                            .background(RoundedRectangle(cornerRadius: 10).fill(Resources.Color.Colors.white))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Resources.Color.Colors.darkPurple, lineWidth: 1))
                        
                        NavigationLink(destination: OnboardingDataAccess()) {
                            Text("login")
                        }
                        .frame(alignment: .center)
                        .buttonStyle(Resources.CustomButtonStyle.SmallFrontPageButtonStyle())
                        Spacer()
                            .frame(height: 200)
                    }
                }
                .padding()
                .ignoresSafeArea(.keyboard)
            }
        }
    }
}

struct LoginPassword_Previews: PreviewProvider {
    static var previews: some View {
        LoginPassword()
    }
}
