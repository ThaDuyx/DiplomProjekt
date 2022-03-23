//  LoginOptions.swift
//  Registr
//
//  Created by Christoffer Detlef on 02/03/2022.
//

import SwiftUI

struct LoginOptions: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 60) {
                Text("application_name")
                    .titleTextStyle()
                VStack(spacing: 40) {
                    NavigationLink(destination: LoginUserID()) {
                        Text("parent_login")
                    }.simultaneousGesture(TapGesture().onEnded{
                        AuthenticationManager.shared.loginSelection = .parent
                    })
                    .buttonStyle(Resources.CustomButtonStyle.FrontPageButtonStyle())
                    NavigationLink(destination: LoginUserID()) {
                        Text("school_login")
                    }.simultaneousGesture(TapGesture().onEnded{
                        AuthenticationManager.shared.loginSelection = .school
                    })
                    .buttonStyle(Resources.CustomButtonStyle.FrontPageButtonStyle())
                    Spacer()
                        .frame(height: 200)
                }
            }
            .background(Image("BackgroundImage")
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
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
