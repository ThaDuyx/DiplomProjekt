//
//  TeacherAbsencesSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import SwiftUI

struct TeacherAbsencesSection: View {
    let report: Report
    
    var body: some View {
        HStack {
            HStack(spacing: 20) {
                Button { } label: {
                    Text(stringSeparator(reason: report.reason.rawValue).uppercased())
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.white)
                        .background(Color.frolyRed)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                
                VStack {
                    Text(report.studentName)
                        .bodyTextStyle(color: Color.white, font: .poppinsBold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(report.description ?? "")
                        .smallBodyTextStyle(color: .white, font: .poppinsRegular)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                }
            }
            
            NavigationLink(destination: StudentReportView(report: report)) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color.white)
                .padding(.trailing, 10)
        }
    }
}

struct TeacherAbsencesSection_Previews: PreviewProvider {
    static var previews: some View {
        TeacherAbsencesSection(report: Report(id: "", parentName: "", parentID: "", studentName: "", studentID: "", className: "", classID: "", date: Date(), endDate: Date(), timeOfDay: .morning, description: "", reason: .illness, registrationType: .notRegistered, validated: false, teacherValidation: .pending, isDoubleRegistrationActivated: false))
    }
}
