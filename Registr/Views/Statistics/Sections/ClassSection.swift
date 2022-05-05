//
//  ClassSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import SwiftUI

struct ClassSection: View {
    let classInfo: ClassInfo
    
    var body: some View {
        HStack {
            Text(classInfo.name)
                .bodyTextStyle(color: Color.white, font: .poppinsBold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            NavigationLink(destination: ClassView(classInfo: classInfo)) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color.white)
                .padding(.trailing, 10)
        }
        .frame(height: 35)
    }
}
struct ClassSection_Previews: PreviewProvider {
    static var previews: some View {
        ClassSection(classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: "", classID: ""))
    }
}
