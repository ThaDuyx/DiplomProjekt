//
//  CalendarView.swift
//  Registr
//
//  Created by Christoffer Detlef on 25/03/2022.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var schoolManager = SchoolManager()
    @State private var selectedDate: Date = Date()
    let classInfo: ClassInfo
    let school: School
    let startDate = Date()
    
    func dateRanges(amountOfDaysSinceStart: Int, amountOfDayssinceStop: Int) -> ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: amountOfDaysSinceStart, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: -amountOfDayssinceStop, to: Date())!
        return min...max
    }
    
    func dateClosedRange(date: Date) -> Int {
        
        print("The date is: \(date)")
        
        var dateComponent = DateComponents()
        dateComponent.day = 251
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: date) ?? .now
        
        // can be used when we get the real date.
//        let date = Calendar.current.startOfDay(for: futureDate)
                
        let components = Calendar.current.dateComponents([.day], from: futureDate, to: .now)
        
        // Force unwraps, since we know that we will have a date, since we have a default value.
        return components.day!
    }
    
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
                DatePicker("", selection: $selectedDate, in: dateRanges(amountOfDaysSinceStart: dateClosedRange(date: school.startDate), amountOfDayssinceStop: dateClosedRange(date: school.endDate)), displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()

                NavigationLink(destination: AbsenceRegistrationView(selectedClass: classInfo, selectedDate: selectedDate.formatSpecificDate(date: selectedDate), isFromHistory: true)) {
                    Text("next_view")
                }
                .buttonStyle(Resources.CustomButtonStyle.SmallFilledButtonStyle())
                .padding(.leading, 200)
            }
        }.environmentObject(schoolManager)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: ""), school: School(startDate: .now, endDate: .now, name: "SchollName"))
    }
}
