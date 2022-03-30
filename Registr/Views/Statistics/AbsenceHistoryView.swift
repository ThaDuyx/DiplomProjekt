//
//  AbsenceHistoryView.swift
//  Registr
//
//  Created by Christoffer Detlef on 25/03/2022.
//

import SwiftUI

struct AbsenceHistoryView: View {
    @State private var date = Date()
    
    private let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: Calendar.current.component(.year, from: Date()),month: 1, day: 1)
        let endComponents = DateComponents(year: Calendar.current.component(.year, from: Date()), month: 12, day: 31)
        return calendar.date(from:startComponents)!
        ...
        calendar.date(from:endComponents)!
    }()
    
    var body: some View {
        ZStack {
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            VStack {
                Text("Den følgende dato er valgt: \(date)")
                    .boldSubTitleTextStyle()
                    .padding()
                DatePicker(
                    "",
                    selection: $date,
                    in: dateRange,
                    displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
            }
        }
    }
}

struct AbsenceHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceHistoryView()
    }
}
