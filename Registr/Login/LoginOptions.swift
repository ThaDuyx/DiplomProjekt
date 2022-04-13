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
                    ZStack {
                        VStack {
                            Rectangle()
                                .fill(Resources.Color.Colors.moonMist.opacity(0.7))
                                .frame(height: 170)
                                .cornerRadius(50, corners: [.bottomLeft, .bottomRight])
                            Spacer()
                        }
                        .ignoresSafeArea()
                        Spacer()
                        VStack {
                            Image("Group 4")
                            Text("application_name")
                                .titleTextStyle()
                        }
                    }
                    VStack(spacing: 40) {
                        NavigationLink(destination: UserIDView(username: "test@test.com")) {
                            Text("parent_login")
                        }.simultaneousGesture(TapGesture().onEnded{
                            AuthenticationManager.shared.loginSelection = .parent
                        })
                            .buttonStyle(Resources.CustomButtonStyle.TransparentButtonStyle())
                        NavigationLink(destination: UserIDView(username: "teacher@test.com")) {
                            Text("school_login")
                        }.simultaneousGesture(TapGesture().onEnded{
                            AuthenticationManager.shared.loginSelection = .school
                        })
                            .buttonStyle(Resources.CustomButtonStyle.TransparentButtonStyle())
                        Spacer()
                            .frame(height: 200)
                    }
                }
            }
            .navigationTitle("")
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
