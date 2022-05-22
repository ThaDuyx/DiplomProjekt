//
//  StudentAbsenceInformationSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import SwiftUI

struct StudentAbsenceInformationSection: View {
    let name: String
    let reason: String
    let date: Date
    let description: String
    let timeOfDay: String
    let endDate: Date?
    
    var body: some View {
        VStack {
            Text("sais_report".localize)
                .bodyTextStyle(color: Color.white, font: .poppinsBold)
            Divider()
                .frame(height: 1)
                .background(.white)
            StudentAbsencesSection(title: "sais_student".localize, icon: "person", description: name)
            StudentAbsencesSection(title: "sais_reason".localize, icon: "questionmark.circle", description: reason)
            StudentAbsencesSection(title: "sais_time".localize, icon: "clock", description: timeOfDay)
            if let endDate = endDate {
                let firstDate = DateFormatter.abbreviationDayMonthYearFormatter.string(from: date)
                let lastDate = DateFormatter.abbreviationDayMonthYearFormatter.string(from: endDate)
                let dateCombined = firstDate + "\n" + lastDate
                StudentAbsencesSection(title: "sais_date".localize, icon: "calendar", description: dateCombined)
            } else {
                StudentAbsencesSection(title: "sais_date".localize, icon: "calendar", description: DateFormatter.abbreviationDayMonthYearFormatter.string(from: date))
            }
            StudentAbsencesSection(title: "sais_description".localize, icon: "note.text", description: description)
        }
        .frame(width: 320)
        .padding(.vertical, 20)
        .background(Color.frolyRed)
        .cornerRadius(20)
    }
}

struct StudentAbsenceInformationSection_Previews: PreviewProvider {
    static var previews: some View {
        StudentAbsenceInformationSection(name: "", reason: "", date: .now, description: "", timeOfDay: "", endDate: nil)
    }
}
