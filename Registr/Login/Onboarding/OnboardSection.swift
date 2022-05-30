//
//  OnboardSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 09/03/2022.
//

import SwiftUI

struct OnboardSection: View {
    var id: Int
    var title: String
    var details: String
    var image: String
    
    var body: some View {
        ZStack {
            VStack {
                
                LogoSection(isOnboarding: true, onboardingImage: image)
                
                Spacer()
                
                VStack {
                    VStack(spacing: 40) {
                        Text(title.localize)
                            .subTitleTextStyle(color: Color.fiftyfifty, font: .poppinsSemiBold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                        
                        Text(details.localize)
                            .subTitleTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
                            .frame(width: 250)
                            .multilineTextAlignment(.leading)
                            .padding(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.frolyRed, lineWidth: 2)
                            )
                    }
                    .offset(y: 40)
                    Spacer()
                }
            }
        }
    }
}

struct OnboardRow_Previews: PreviewProvider {
    static var previews: some View {
        OnboardSection(id: 1, title: "onboard_flow_page_one_title", details: "onboard_flow_page_one_description", image: "checkmark.shield.fill")
    }
}
