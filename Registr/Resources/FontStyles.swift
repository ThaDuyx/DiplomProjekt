//
//  FontStyles.swift
//  Registr
//
//  Created by Christoffer Detlef on 02/03/2022.
//

import SwiftUI

extension Text {
    /// Color: darkPurple, FontSize: 64pt
    func titleTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.darkPurple)
            .font(.custom("Poppins-SemiBold", size: Resources.FontSize.title))
    }
    
    /// Color: darkPurple, FontSize: 24pt
    func primaryHeaderTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.darkPurple)
            .font(.custom("Poppins-Medium", size: Resources.FontSize.primaryHeader))
    }
    
    /// Color: darkPurple, FontSize: 18pt
    func subTitleTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.darkPurple)
            .font(.custom("Poppins-Regular", size: Resources.FontSize.subTitle))
    }
    
    /// Color: darkPurple, FontSize: 14pt
    func darkBodyTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.darkPurple)
            .font(.custom("Poppins-", size: Resources.FontSize.body))
    }
    
    /// Color: lightMint, FontSize: 14pt
    func lightBodyTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.lightMint)
            .font(.custom("Poppins-", size: Resources.FontSize.body))
    }
}
