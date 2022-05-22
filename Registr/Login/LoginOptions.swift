//  LoginOptions.swift
//  Registr
//
//  Created by Christoffer Detlef on 02/03/2022.
//

import SwiftUI

struct LoginOptions: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
                    LogoSection(isOnboarding: false)
                    
                    Spacer()
                    
                    VStack(spacing: 40) {
                        NavigationLink(destination: UserIDView(username: "test@test.com")) {
                            Text("parent_login")
                        }.simultaneousGesture(TapGesture().onEnded{
                            AuthenticationManager.shared.loginSelection = .parent
                        })
                            .buttonStyle(Resources.CustomButtonStyle.LoginOptionsButtonStyle())
                            .accessibilityIdentifier("parentNavigationLink")
                        NavigationLink(destination: UserIDView(username: "teacher@test.com")) {
                            Text("school_login")
                        }.simultaneousGesture(TapGesture().onEnded{
                            AuthenticationManager.shared.loginSelection = .school
                        })
                            .buttonStyle(Resources.CustomButtonStyle.LoginOptionsButtonStyle())
                            .accessibilityIdentifier("teacherNavigationLink")
                        Spacer()
                    }
                    .offset(y: 80)
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear() {
            NavigationAndTabbarAppearance.configureAppearance(clear: true)
        }
    }
}

struct LoginOptions_Previews: PreviewProvider {
    static var previews: some View {
        LoginOptions()
    }
}
