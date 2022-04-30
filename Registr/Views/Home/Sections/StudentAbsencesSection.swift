//
//  StudentAbsencesSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import SwiftUI


struct StudentAbsencesSection : View {
    let title: String
    let icon: String
    let description: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .smallBodyTextStyle(color: .white, font: .poppinsBold)
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.white)
                Text(description)
                    .smallBodyTextStyle(color: .white, font: .poppinsRegular)
                    .padding(4)
            }
            .padding(.leading, 10)
            .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 1)
            )
        }
        .frame(width: 275)
    }
}

struct StudentAbsencesSection_Previews: PreviewProvider {
    static var previews: some View {
        StudentAbsencesSection(title: "", icon: "", description: "")
    }
}
