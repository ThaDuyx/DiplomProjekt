//
//  StudentSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import SwiftUI

struct StudentSection: View {
    let studentName: String
    let studentID: String
    
    var body: some View {
        HStack {
            Text(studentName)
                .bodyTextStyle(color: Color.white, font: .poppinsBold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            NavigationLink(destination: StudentView(studentName: studentName, isParent: false, studentID: studentID)) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)

            Image(systemName: "chevron.right")
                .foregroundColor(Color.white)
                .padding(.trailing, 10)
        }
        .frame(height: 35)
    }
}

struct StudentSection_Previews: PreviewProvider {
    static var previews: some View {
        StudentSection(studentName: "", studentID: "")
    }
}
