//
//  ErrorView.swift
//  Registr
//
//  Created by Christoffer Detlef on 21/04/2022.
//

import SwiftUI

struct ErrorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let title: String
    let error: String
    var action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 130, height: 130)
                .foregroundColor(.frolyRed)
            VStack(spacing: 10) {
                Text(title)
                    .headerTextStyle(color: .fiftyfifty, font: .poppinsMedium)
                    .frame(width: 320, alignment: .leading)
                
                Text(error)
                    .bodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
                    .frame(width: 320, alignment: .center)
            }
            Spacer()
            
            Button(action: {
                action?()
                presentationMode.wrappedValue.dismiss()
            } ) {
                Text("alert_button_title".localize)
            }
            .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsSemiBold, fontSize: Resources.FontSize.primaryHeader))
            .padding(.bottom, 20)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(title: "alert_title_login".localize, error: "The password is invalid or the user does not have a password.") { }
    }
}
