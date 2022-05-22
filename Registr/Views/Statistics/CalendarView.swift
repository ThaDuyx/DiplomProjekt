//
//  CalendarView.swift
//  Registr
//
//  Created by Christoffer Detlef on 25/03/2022.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var schoolManager = SchoolViewModel()
    @StateObject var errorHandling = ErrorHandling()
    @State private var selectedDate: Date = Date()
    let classInfo: ClassInfo
    let startDate = Date()

    var body: some View {
        ZStack {
            VStack {
                VStack(spacing: 0) {
                    Text("absence_day_pick")
                        .subTitleTextStyle(color: Color.fiftyfifty, font: .poppinsBold)
                        .padding(.horizontal)
                    let date = DateFormatter.abbreviationDayMonthYearFormatter.string(from: selectedDate)
                    Text(date)
                        .subTitleTextStyle(color: Color.fiftyfifty, font: .poppinsBold)
                        .padding(.horizontal)
                }
                if let school = schoolManager.school {
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        in: dateRanges(amountOfDaysSinceStart: dateClosedRange(date: school.startDate), amountOfDayssinceStop: dateClosedRange(date: school.endDate)),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                }
                NavigationLink(destination: AbsenceRegistrationView(selectedClass: classInfo, selectedDate: selectedDate, isFromHistory: true)) {
                    Text("next_view")
                }
                .buttonStyle(Resources.CustomButtonStyle.SmallFilledButtonStyle())
                .padding(.leading, 200)
            }
            .fullScreenCover(item: $errorHandling.appError) { appError in
                ErrorView(title: appError.title, error: appError.description) {
                    schoolManager.fetchSchool()
                }
            }
        }.environmentObject(schoolManager)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: "", classID: ""))
    }
}
