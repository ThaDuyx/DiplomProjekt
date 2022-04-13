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
                .font(.custom("Poppins-Light", size: Resources.FontSize.primaryHeader))
                .foregroundColor(Resources.Color.Colors.lightMint)
                .background(Resources.Color.Colors.darkBlue)
                .cornerRadius(5)
        }
    }
    
    struct SmallFrontPageButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 280, height: 50)
                .font(.custom("Poppins-Light", size: Resources.FontSize.primaryHeader))
                .foregroundColor(Resources.Color.Colors.white)
                .background(Resources.Color.Colors.frolyRed)
                .cornerRadius(20)
        }
    }
    
    struct FilledButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 290, height: 50)
                .font(.custom("Poppins-SemiBold", size: Resources.FontSize.body))
                .foregroundColor(Resources.Color.Colors.lightMint)
                .background(Resources.Color.Colors.darkBlue)
                .cornerRadius(2)
        }
    }
    
    struct TransparentButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 290, height: 65)
                .font(.custom("Poppins-SemiBold", size: Resources.FontSize.primaryHeader))
                .foregroundColor(Resources.Color.Colors.frolyRed)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Resources.Color.Colors.frolyRed, lineWidth: 2)
                )
        }
    }
    
    struct RegisterButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 120, height: 50)
                .font(.custom("Poppins-Light", size: Resources.FontSize.subTitle))
                .foregroundColor(Resources.Color.Colors.lightMint)
                .background(Resources.Color.Colors.darkBlue)
                .cornerRadius(5)
        }
    }
    
    struct DeclineButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 120, height: 50)
                .font(.custom("Poppins-Light", size: Resources.FontSize.subTitle))
                .foregroundColor(Resources.Color.Colors.darkPurple)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Resources.Color.Colors.darkPurple, lineWidth: 1)
                )
        }
    }
    
    struct ActionButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 50, height: 50)
                .font(.custom("Poppins-Regular", size: Resources.FontSize.subTitle))
                .foregroundColor(Resources.Color.Colors.lightMint)
                .background(Resources.Color.Colors.darkBlue)
                .cornerRadius(5)
        }
    }
    
    struct FollowButtonStyle: ButtonStyle {
        let backgroundColor: Color
        let textColor: Color
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(width: 185, height: 40)
                .font(.custom("Poppins-Medium", size: Resources.FontSize.subTitle))
                .foregroundColor(textColor)
                .background(backgroundColor)
                .border(Resources.Color.Colors.darkPurple, width: 1)
                .cornerRadius(2)
        }
    }
}
