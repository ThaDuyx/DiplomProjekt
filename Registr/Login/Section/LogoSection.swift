//
//  LogoSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 06/05/2022.
//

import SwiftUI

struct LogoSection: View {
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color.moonMist.opacity(0.7))
                .frame(height: 170)
                .cornerRadius(50, corners: [.bottomLeft, .bottomRight])
            
            Spacer()
            
            VStack(spacing: 0) {
                Image("AppLogo")
                Text("application_name".localize)
                    .titleTextStyle(color: .frolyRed, font: .poppinsSemiBold)
            }
            .offset(y: 80)
        }
        .ignoresSafeArea()
    }
}

struct LogoSection_Previews: PreviewProvider {
    static var previews: some View {
        LogoSection()
    }
}
