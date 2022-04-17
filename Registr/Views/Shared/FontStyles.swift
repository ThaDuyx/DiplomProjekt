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
        self.foregroundColor(Resources.Color.Colors.frolyRed)
            .font(.custom("Poppins-SemiBold", size: Resources.FontSize.title))
    }
    
    /// Color: darkPurple, FontSize: 24pt
    func primaryHeaderTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.frolyRed)
            .font(.custom("Poppins-Medium", size: Resources.FontSize.primaryHeader))
    }
    
    /// Color: darkPurple, FontSize: 18pt
    func subTitleTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.darkPurple)
            .font(.custom("Poppins-Regular", size: Resources.FontSize.subTitle))
    }
    
    /// Color: lightMint, FontSize: 18pt
    func lightSubTitleTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.lightMint)
            .font(.custom("Poppins-Regular", size: Resources.FontSize.subTitle))
    }
    
    /// Color: fiftyfifty, FontSize: 24pt
    func headerTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.fiftyfifty)
            .font(.custom("Poppins-Medium", size: Resources.FontSize.primaryHeader))
    }
    
    /// Color: fiftyfifty, FontSize: 18pt
    func boldSubTitleTextStyle(color: Color) -> some View {
        self.foregroundColor(color)
            .font(.custom("Poppins-Bold", size: Resources.FontSize.subTitle))
    }
    
    /// Color: darkPurple, FontSize: 14pt
    func darkBodyTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.darkPurple)
            .font(.custom("Poppins-Regular", size: Resources.FontSize.body))
    }
    
    /// Color: lightMint, FontSize: 14pt
    func lightBodyTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.white)
            .font(.custom("Poppins-Regular", size: Resources.FontSize.body))
    }
    
    /// Color: lightMint, FontSize: 14pt
    func boldLightBodyTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.lightMint)
            .font(.custom("Poppins-Medium", size: Resources.FontSize.body))
    }
    
    /// Color: white, FontSize: 14pt
    func darkBlueBodyTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.darkBlue)
            .font(.custom("Poppins-Medium", size: Resources.FontSize.body))
    }
    
    /// Color: darkPurple, FontSize: 14pt
    func darkBoldBodyTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.darkPurple)
            .font(.custom("Poppins-Medium", size: Resources.FontSize.body))
    }
    
    /// Color: white, FontSize: 14pt
    func boldBodyTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.white)
            .font(.custom("Poppins-Bold", size: Resources.FontSize.body))
    }
    
    /// Color: fiftyfifty, FontSize: 14pt
    func boldDarkBodyTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.fiftyfifty)
            .font(.custom("Poppins-Bold", size: Resources.FontSize.body))
    }
    
    /// Color: white, FontSize: 12pt
    func smallBodyTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.white)
            .font(.custom("Poppins-Regular", size: Resources.FontSize.smallBody))
    }
    
    /// Color: white, FontSize: 12pt
    func boldSmallBodyTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.white)
            .font(.custom("Poppins-Bold", size: Resources.FontSize.smallBody))
    }
    
    /// Color: fiftyfifty, FontSize: 12pt
    func boldDarkSmallBodyTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.fiftyfifty)
            .font(.custom("Poppins-Bold", size: Resources.FontSize.smallBody))
    }
    
    /// Color: FiftyFifty, FontSize: 16pt
    func bigBodyTextStyle(color: Color) -> some View {
        self.foregroundColor(color)
            .font(.custom("Poppins-Regular", size: Resources.FontSize.bigBody))
    }
    
    /// Color: FiftyFifty, FontSize: 16pt
    func bigBoldBodyTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.fiftyfifty)
            .font(.custom("Poppins-Bold", size: Resources.FontSize.bigBody))
    }
    
    func smallSubTitleTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.white)
            .font(.custom("Poppins-SemiBold", size: Resources.FontSize.subTitle))
    }
    
    func mediumSubTitleTextStyle(color: Color, font: String) -> some View {
        self.foregroundColor(color)
            .font(.custom(font, size: Resources.FontSize.subTitle))
    }
}

extension TextEditor {
    /// Color: lightMint, FontSize: 14pt
    func lightBodyTextStyleTextEditor() -> some View {
        self.foregroundColor(Resources.Color.Colors.lightMint)
            .font(.custom("Poppins-Regular", size: Resources.FontSize.body))
    }
}

extension Toggle {
    func lightBodyTextStyleToggle() -> some View {
        self.foregroundColor(Resources.Color.Colors.lightMint)
            .font(.custom("Poppins-Regular", size: Resources.FontSize.body))
    }
}
