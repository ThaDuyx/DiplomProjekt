//
//  LoginPassword.swift
//  Registr
//
//  Created by Christoffer Detlef on 03/03/2022.
//

import SwiftUI

struct LoginPassword: View {
    @State private var password: String = "test1234"
    @State private var isPresented = false
    @State private var showActivity = false
    var userName: String

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
                        SecureField("password_field_text".localize, text: $password)
                            .frame(width: 265, height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                            .background(RoundedRectangle(cornerRadius: 10).fill(Resources.Color.Colors.white))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Resources.Color.Colors.darkPurple, lineWidth: 1))
                        Button("login") {
                            showActivity = true
                            AuthenticationManager.shared.signIn(email: userName, password: password, completion: { success in
                                if success {
                                    showActivity = false
                                    print(success)
                                    isPresented.toggle()
                                } else {
                                    showActivity = false
                                    // TODO: Present error Message || View
                                }
                            })
                        }
                        .fullScreenCover(isPresented: $isPresented, content: OnboardingControllerFlow.init)
                        .frame(alignment: .center)
                        .buttonStyle(Resources.CustomButtonStyle.SmallFrontPageButtonStyle())
                        if showActivity {
                            ProgressView()
                                .foregroundColor(Resources.Color.Colors.darkBlue)
                        }
                        //Toggle("Hide", isOn: $isHidden)
                        
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
        LoginPassword(userName: "thisisme")
    }
}
