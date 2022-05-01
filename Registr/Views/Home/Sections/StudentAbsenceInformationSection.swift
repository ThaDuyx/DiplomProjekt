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
            StudentAbsencesSection(title: "Dato", icon: "calendar", description: DateFormatter.abbreviationDayMonthYearFormatter.string(from: date))
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
        StudentAbsenceInformationSection(name: "", reason: "", date: .now, description: "", timeOfDay: "")
    }
}
