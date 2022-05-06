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
                    
                    LogoSection()
                    
                    Spacer()
                    
                    VStack(spacing: 40) {
                        NavigationLink(destination: UserIDView(username: "test@test.com")) {
                            Text("parent_login")
                        }.simultaneousGesture(TapGesture().onEnded{
                            AuthenticationManager.shared.loginSelection = .parent
                        })
                            .buttonStyle(Resources.CustomButtonStyle.LoginOptionsButtonStyle())
                        NavigationLink(destination: UserIDView(username: "teacher@test.com")) {
                            Text("school_login")
                        }.simultaneousGesture(TapGesture().onEnded{
                            AuthenticationManager.shared.loginSelection = .school
                        })
                            .buttonStyle(Resources.CustomButtonStyle.LoginOptionsButtonStyle())
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
