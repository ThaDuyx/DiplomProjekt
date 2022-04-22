//
//  PasswordView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/04/2022.
//

import SwiftUI
import SwiftUIKit

struct PasswordView: View {
    @State private var password: String = "test1234"
    @State private var showActivity = false
    @StateObject private var context = FullScreenCoverContext()

    var userName: String
    
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(Resources.Color.Colors.moonMist.opacity(0.7))
                        .frame(height: 170)
                        .cornerRadius(50, corners: [.bottomLeft, .bottomRight])
                    Spacer()
                    VStack(spacing: 0) {
                        Image("Group 4")
                        Text("application_name")
                            .titleTextStyle()
                    }
                    .offset(y: 80)
                }
                .ignoresSafeArea()
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("password")
                        .primaryHeaderTextStyle()
                        .frame(width: 280, alignment: .leading)
                    
                    SecureField("password_field_text".localize, text: $password)
                        .darkBodyTextStyle()
                        .frame(width: 265, height: 40)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        .background(RoundedRectangle(cornerRadius: 10).fill(Resources.Color.Colors.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Resources.Color.Colors.frolyRed, lineWidth: 2))
                    
                    Button("login") {
                        showActivity = true
                        AuthenticationManager.shared.signIn(email: userName, password: password, completion: { success in
                            if success {
                                showActivity = false
                                let window = UIApplication
                                    .shared
                                    .connectedScenes
                                    .flatMap{( $0 as? UIWindowScene)?.windows ?? [] }
                                    .first { $0.isKeyWindow }
                                window?.rootViewController = UIHostingController(rootView: OnboardingControllerFlow())
                                
                            } else {
                                context.present(ErrorView(error: "alert_default_description".localize))
                                showActivity = false
                            }
                        })
                    }
                    .frame(alignment: .center)
                    .buttonStyle(Resources.CustomButtonStyle.SmallFrontPageButtonStyle())
                    
                    if showActivity {
                        ProgressView()
                            .foregroundColor(Resources.Color.Colors.frolyRed)
                    }
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        .fullScreenCover(context)
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(userName: "thisisme")
    }
}
