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
    
    struct FilledWideButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 290, height: 50)
                .font(.custom("Poppins-SemiBold", size: Resources.FontSize.primaryHeader))
                .foregroundColor(Resources.Color.Colors.white)
                .background(Resources.Color.Colors.frolyRed)
                .cornerRadius(20)
        }
    }
    
    struct FilledSmallButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 145, height: 50)
                .font(.custom("Poppins-Regular", size: Resources.FontSize.bigBody))
                .foregroundColor(Resources.Color.Colors.white)
                .background(Resources.Color.Colors.frolyRed)
                .cornerRadius(20)
        }
    }
    
    struct FilledBodyTextButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 290, height: 50)
                .font(.custom("Poppins-Bold", size: Resources.FontSize.body))
                .foregroundColor(Resources.Color.Colors.white)
                .background(Resources.Color.Colors.frolyRed)
                .cornerRadius(20)
        }
    }
    
    struct RegisterButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 120, height: 50)
                .font(.custom("Poppins-Regular", size: Resources.FontSize.subTitle))
                .foregroundColor(Resources.Color.Colors.white)
                .background(Resources.Color.Colors.frolyRed)
                .cornerRadius(20)
        }
    }
    
    struct DeclineButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return configuration.label
                .frame(width: 120, height: 50)
                .font(.custom("Poppins-Regular", size: Resources.FontSize.subTitle))
                .foregroundColor(Resources.Color.Colors.frolyRed)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Resources.Color.Colors.frolyRed, lineWidth: 2)
                )
        }
    }
    
    struct TransparentFollowButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(width: 170, height: 45)
                .font(.custom("Poppins-Regular", size: Resources.FontSize.subTitle))
                .foregroundColor(Resources.Color.Colors.frolyRed)
                .background(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Resources.Color.Colors.frolyRed, lineWidth: 2)
                )
        }
    }
}
