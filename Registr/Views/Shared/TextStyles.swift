//
//  TextStyles.swift
//  Registr
//
//  Created by Christoffer Detlef on 02/03/2022.
//

import SwiftUI

extension Text {
    
    /// Color: color, Font: font, FontSize: 64pt
    func titleTextStyle(color: Color, font: String) -> some View {
        self.foregroundColor(color)
            .font(.custom(font, size: Resources.FontSize.title))
    }
    
    /// Color: color, Font: font, FontSize: 24pt
    func headerTextStyle(color: Color, font: String) -> some View {
        self.foregroundColor(color)
            .font(.custom(font, size: Resources.FontSize.primaryHeader))
    }
    
    /// Color: color, Font: font, FontSize: 18pt
    func subTitleTextStyle(color: Color, font: String) -> some View {
        self.foregroundColor(color)
            .font(.custom(font, size: Resources.FontSize.subTitle))
    }
    
    /// Color: color, Font: font, FontSize: 16pt
    func bigBodyTextStyle(color: Color, font: String) -> some View {
        self.foregroundColor(color)
            .font(.custom(font, size: Resources.FontSize.bigBody))
    }
    
    /// Color: color, Font: font, FontSize: 14pt
    func bodyTextStyle(color: Color, font: String) -> some View {
        self.foregroundColor(color)
            .font(.custom(font, size: Resources.FontSize.body))
    }
    
    /// Color: color, Font: font, FontSize: 12pt
    func smallBodyTextStyle(color: Color, font: String) -> some View {
        self.foregroundColor(color)
            .font(.custom(font, size: Resources.FontSize.smallBody))
    }
}

extension TextField {
    /// Color: color, Font: font, Size: size
    func textStyleTextField(color: Color, font: String, size: CGFloat) -> some View {
        self.foregroundColor(color)
            .font(.custom(font, size: size))
    }
}

extension TextEditor {
    /// Color: color, Font: font, Size: size
    func textStyleTextEditor(color: Color, font: String, size: CGFloat) -> some View {
        self.foregroundColor(color)
            .font(.custom(font, size: size))
    }
}

extension Toggle {
    /// Color: color, Font: font, Size: size
    func textStyleToggle(color: Color, font: String, size: CGFloat) -> some View {
        self.foregroundColor(color)
            .font(.custom(font, size: size))
    }
}

extension SecureField {
    /// Color: color, Font: font, Size: size
    func bodyTextStyle(color: Color, font: String, size: CGFloat) -> some View {
        self.foregroundColor(color)
            .font(.custom(font, size: size))
    }
}
