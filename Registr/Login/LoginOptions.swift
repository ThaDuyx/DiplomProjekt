//  LoginOptions.swift
//  Registr
//
//  Created by Christoffer Detlef on 02/03/2022.
//

import SwiftUI

struct LoginOptions: View {
    init() {
        NavigationAndTabbarAppearance.configureAppearance()
    }
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ZStack(alignment: .top) {
                        Rectangle()
                            .fill(Color.moonMist.opacity(0.7))
                            .frame(height: 170)
                            .cornerRadius(50, corners: [.bottomLeft, .bottomRight])
                        Spacer()
                        VStack {
                            Image("AppLogo")
                            Text("application_name")
                                .titleTextStyle(color: .frolyRed, font: .poppinsSemiBold)
                        }
                        .offset(y: 80)
                    }
                    .ignoresSafeArea()
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
    }
}

struct LoginOptions_Previews: PreviewProvider {
    static var previews: some View {
        LoginOptions()
    }
}
