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
            Text("Indberettelse")
                .bodyTextStyle(color: Color.white, font: .poppinsBold)
            Divider()
                .frame(height: 1)
                .background(.white)
            StudentAbsencesSection(title: "Elev", icon: "person", description: name)
            StudentAbsencesSection(title: "Årsag", icon: "questionmark.circle", description: reason)
            StudentAbsencesSection(title: "Tidspunkt", icon: "clock", description: timeOfDay)
            if let endDate = endDate {
                let firstDate = DateFormatter.abbreviationDayMonthYearFormatter.string(from: date)
                let lastDate = DateFormatter.abbreviationDayMonthYearFormatter.string(from: endDate)
                let dateCombined = firstDate + "\n" + lastDate
                StudentAbsencesSection(title: "Dato", icon: "calendar", description: dateCombined)
            } else {
                StudentAbsencesSection(title: "Dato", icon: "calendar", description: DateFormatter.abbreviationDayMonthYearFormatter.string(from: date))
            }
            StudentAbsencesSection(title: "Beskrivelse", icon: "note.text", description: description)
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
