//
//  UserIDView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/04/2022.
//

import SwiftUI

struct UserIDView: View {
    
    @State private var userName: String
    var username: String
    
    init(username: String) {
        self.username = username
        userName = username
    }
    
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
                    Text("user_id")
                        .primaryHeaderTextStyle()
                        .frame(width: 280, alignment: .leading)
                    TextField("user_id_field_text".localize, text: $userName)
                        .frame(width: 265, height: 40)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        .background(RoundedRectangle(cornerRadius: 10).fill(Resources.Color.Colors.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Resources.Color.Colors.frolyRed, lineWidth: 2))
                    
                    NavigationLink(destination: PasswordView(userName: userName)) {
                        Text("next_view")
                    }
                    .frame(alignment: .center)
                    .buttonStyle(Resources.CustomButtonStyle.SmallFrontPageButtonStyle())
                    Spacer()
                }
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

struct UserIDView_Previews: PreviewProvider {
    static var previews: some View {
        UserIDView(username: "")
    }
}
