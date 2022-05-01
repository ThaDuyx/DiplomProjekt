//
//  RegistrationClassSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import SwiftUI

struct RegistrationClassSection: View {
    var classInfo: ClassInfo
    var isFavorite: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(Color.white)
                
                Text(classInfo.name)
                    .subTitleTextStyle(color: .white, font: .poppinsSemiBold)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            // Setting frame and opacity to 0, to remove chevron
            NavigationLink(destination: AbsenceRegistrationView(selectedClass: classInfo, selectedDate: Date(), isFromHistory: false)) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color.white)
                .padding(.trailing, 10)
        }
        .frame(height: 55)
    }
}
struct RegistrationClassSection_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationClassSection(classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: ""), isFavorite: false)
    }
}
