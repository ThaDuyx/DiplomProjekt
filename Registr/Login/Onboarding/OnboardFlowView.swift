//
//  OnboardFlowView.swift
//  Registr
//
//  Created by Christoffer Detlef on 09/03/2022.
//

import SwiftUI

struct OnboardFlowView: View {
    var id: Int
    var title: String
    var details: String
    var image: String
    var buttonText: String
    
    var body: some View {
        ZStack {
            VStack {
                VStack(spacing: 30) {
                    Text(title.localize)
                        .primaryHeaderTextStyle()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                    
                    Text(details.localize)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                }
                Spacer()
                VStack(spacing: 20) {
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Resources.Color.Colors.frolyRed)
                        .padding(100)
                }
                Spacer()
            }
        }
    }
}

struct OnboardFlowView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardFlowView(id: 1, title: "onboard_flow_page_one_title", details: "onboard_flow_page_one_description", image: "checkmark.shield.fill", buttonText: "onboard_flow_page_one_button_text")
    }
}
