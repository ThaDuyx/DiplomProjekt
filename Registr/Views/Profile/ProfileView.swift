//
//  ProfileView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            NotificationRow()
                .padding(.top, 20)
            Spacer()
            Button {
                print("You have logout")
            } label: {
                Text("Log ud")
            }
            .buttonStyle(Resources.CustomButtonStyle.FilledWideButtonStyle())
            Text("app_info")
                .smallDarkBodyTextStyle()
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
