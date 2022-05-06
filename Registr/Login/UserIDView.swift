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
                
                LogoSection()
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("user_id")
                        .headerTextStyle(color: .frolyRed, font: .poppinsMedium)
                        .frame(width: 290, alignment: .leading)
                    
                    TextField("user_id_field_text".localize, text: $userName)
                        .textStyleTextField(color: .fiftyfifty, font: .poppinsMedium, size: Resources.FontSize.body)
                        .frame(width: 275, height: 40)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.frolyRed, lineWidth: 2))
                    
                    NavigationLink(destination: PasswordView(userName: userName)) {
                        Text("next_view")
                    }
                    .frame(alignment: .center)
                    .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsSemiBold, fontSize: Resources.FontSize.primaryHeader))
                    
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
