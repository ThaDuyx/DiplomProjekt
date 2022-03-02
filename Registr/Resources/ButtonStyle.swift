//
//  ButtonStyle.swift
//  Registr
//
//  Created by Christoffer Detlef on 02/03/2022.
//

import SwiftUI

extension Resources {
    enum CustomButtonStyle {}
}
extension Resources.CustomButtonStyle {
    struct FrontPageButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 280, height: 55)
                .font(.system(size: Resources.FontSize.frontPageButton))
                .foregroundColor(Resources.Color.Colors.lightMint)
                .background(Resources.Color.Colors.darkBlue)
                .cornerRadius(5)
        }
    }
}
