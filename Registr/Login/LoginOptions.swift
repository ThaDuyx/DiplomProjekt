//
//  LoginOptions.swift
//  Registr
//
//  Created by Christoffer Detlef on 02/03/2022.
//

import SwiftUI

struct LoginOptions: View {
    var body: some View {
        ZStack {
            VStack(spacing: 80) {
                Text("application_name")
                    .titleTextStyle()
                Button("parent_login") {
                    
                }
                .buttonStyle(Resources.CustomButtonStyle.FrontPageButtonStyle())
                Button("school_login") {
                    
                }
                .buttonStyle(Resources.CustomButtonStyle.FrontPageButtonStyle())
            }
        }
        .background(Image("BackgroundImage")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
    }
}

struct LoginOptions_Previews: PreviewProvider {
    static var previews: some View {
        LoginOptions()
    }
}
