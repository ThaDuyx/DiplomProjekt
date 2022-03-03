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
                .frame(width: 290, height: 50)
                .font(.custom("Poppins-SemiBold", size: Resources.FontSize.subTitle))
                .foregroundColor(Resources.Color.Colors.darkPurple)
                .background(Color.clear)
                .border(Resources.Color.Colors.darkPurple, width: 1)
                .cornerRadius(2)
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
                .border(Resources.Color.Colors.darkPurple, width: 1)
                .cornerRadius(5)
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
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 115, height: 40)
                .font(.custom("Poppins-Medium", size: Resources.FontSize.subTitle))
                .foregroundColor(Resources.Color.Colors.darkPurple)
                .background(Color.clear)
                .border(Resources.Color.Colors.darkPurple, width: 1)
                .cornerRadius(2)
        }
    }
}
