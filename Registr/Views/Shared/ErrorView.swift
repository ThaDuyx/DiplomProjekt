//
//  ErrorView.swift
//  Registr
//
//  Created by Christoffer Detlef on 21/04/2022.
//

import SwiftUI

struct ErrorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let error: String
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 130, height: 130)
                .foregroundColor(.frolyRed)
            
            Text("alert_title")
                .headerTextStyle(color: Color.fiftyfifty, font: .poppinsMedium)
            
            Text(error)
                .bodyTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
            
            Spacer()
            
            Button{
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("alert_button_title")
            }
            .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsSemiBold, fontSize: Resources.FontSize.primaryHeader))
            .padding(.bottom, 20)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: "Error code 101")
    }
}
