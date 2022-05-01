//
//  StatisticsButtonSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import SwiftUI

struct StatisticsButtonSection<TargetView: View>: View {
    let systemName: String
    let titleText: String
    let destination: TargetView
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: systemName)
                    .frame(alignment: .leading)
                    .padding(.leading, 20)
                Text(titleText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.leading, -50)
            }
        }
        .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsBold, fontSize: Resources.FontSize.body))
    }
}
struct StatisticsButtonSection_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsButtonSection(systemName: "", titleText: "", destination: EmptyView())
    }
}
