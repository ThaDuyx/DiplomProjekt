//
//  LoginUserID.swift
//  Registr
//
//  Created by Christoffer Detlef on 03/03/2022.
//

import SwiftUI

struct LoginUserID: View {
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
                        Text("user_id")
                            .primaryHeaderTextStyle()
                            .frame(width: 280, alignment: .leading)
                        TextField("user_id_field_text".localize, text: $userID)
                            .frame(width: 265, height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                            .background(RoundedRectangle(cornerRadius: 10).fill(Resources.Color.Colors.white))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Resources.Color.Colors.darkPurple, lineWidth: 1))
                        
                        NavigationLink(destination: LoginPassword()) {
                            Text("next_view")
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

struct LoginUserID_Previews: PreviewProvider {
    static var previews: some View {
        LoginUserID()
    }
}
