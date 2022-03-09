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
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            VStack {
                VStack(spacing: 30) {
                    Text(title.localize)
                        .primaryHeaderTextStyle()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                    
                    Text(details.localize)
                        .subTitleTextStyle()
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                }
                Spacer()
                VStack(spacing: 20) {
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Resources.Color.Colors.darkBlue)
                        .padding(100)
                }
                Spacer()
            }
        }
    }
}

struct OnboardFlowView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardFlowView(id: 1, title: "onboard_flow_page_one_title", details: "For at appen kan fungere som den skal, så skal den bruge adgang til din data. Du skal derfor give appen lov til at tilgå data om dig. Dette kan til hvert et tidspunkt ændres.", image: "checkmark.shield.fill", buttonText: "Tillad adgang")
    }
}
