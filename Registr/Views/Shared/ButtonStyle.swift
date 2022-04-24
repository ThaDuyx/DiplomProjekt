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
    
    /// Width: 290 - Height: 65, Font: SemiBold, FontSize: 24pt
    struct LoginOptionsButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 290, height: 65)
                .font(.custom(.poppinsSemiBold, size: Resources.FontSize.primaryHeader))
                .foregroundColor(.frolyRed)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.frolyRed, lineWidth: 2)
                )
        }
    }
    /// Width: 290 - Height: 50, Color: color, FontSize: fontSize
    struct StandardButtonStyle: ButtonStyle {
        let font: String
        let fontSize: CGFloat
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 290, height: 50)
                .font(.custom(font, size: fontSize))
                .foregroundColor(Color.white)
                .background(Color.frolyRed)
                .cornerRadius(20)
        }
    }
    
    struct SmallFilledButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 120, height: 50)
                .font(.custom(.poppinsRegular, size: Resources.FontSize.subTitle))
                .foregroundColor(Color.white)
                .background(Color.frolyRed)
                .cornerRadius(20)
        }
    }
    
    struct SmallTransparentButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 120, height: 50)
                .font(.custom(.poppinsRegular, size: Resources.FontSize.subTitle))
                .foregroundColor(.frolyRed)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.frolyRed, lineWidth: 2)
                )
        }
    }
    
    struct FollowButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(width: 170, height: 45)
                .font(.custom(.poppinsRegular, size: Resources.FontSize.subTitle))
                .foregroundColor(.frolyRed)
                .background(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.frolyRed, lineWidth: 2)
                )
        }
    }
}
