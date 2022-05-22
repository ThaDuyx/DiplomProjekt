//
//  PasswordView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/04/2022.
//

import SwiftUI

struct PasswordView: View {
    @State private var password: String = "test1234"
    @State private var showActivity = false
    @State private var isPresented = false
    @State private var presentedDescription = ""
    @EnvironmentObject var notificationVM: NotificationViewModel

    var userName: String
    
    var body: some View {
        ZStack {
            VStack {
                
                LogoSection(isOnboarding: false)
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("password")
                        .headerTextStyle(color: .frolyRed, font: .poppinsMedium)
                        .frame(width: 290, alignment: .leading)
                    
                    SecureField("password_field_text".localize, text: $password)
                        .bodyTextStyle(color: .fiftyfifty, font: .poppinsMedium, size: Resources.FontSize.body)
                        .frame(width: 275, height: 40)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.frolyRed, lineWidth: 2))
                        .accessibilityIdentifier("passwordTextField")
                    
                    Button("login") {
                        showActivity = true
                        AuthenticationManager.shared.signIn(email: userName, password: password, completion: { success, error  in
                            if success {
                                showActivity = false
                                let window = UIApplication
                                    .shared
                                    .connectedScenes
                                    .flatMap{( $0 as? UIWindowScene)?.windows ?? [] }
                                    .first { $0.isKeyWindow }
                                window?.rootViewController = UIHostingController(rootView: OnboardingControllerFlow().environmentObject(notificationVM))
                                
                            } else {
                                if error != nil {
                                    presentedDescription = error!.localizedDescription
                                    isPresented.toggle()
                                    showActivity = false
                                } else {
                                    presentedDescription = "alert_default_description".localize
                                    isPresented.toggle()
                                    showActivity = false
                                }
                            }
                        })
                    }
                    .frame(alignment: .center)
                    .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsSemiBold, fontSize: Resources.FontSize.primaryHeader))
                    .accessibilityIdentifier("passwordLogin")
                    
                    if showActivity {
                        ProgressView()
                            .foregroundColor(.frolyRed)
                    }
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        .fullScreenCover(isPresented: $isPresented) {
           ErrorView.init(title: "alert_title_login".localize, error: presentedDescription)
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(userName: "thisisme")
    }
}
