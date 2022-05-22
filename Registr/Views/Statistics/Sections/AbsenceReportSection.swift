//
//  AbsenceReportSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import SwiftUI

struct AbsenceReportSection: View {
    @EnvironmentObject var childrenViewModel: ChildrenViewModel
    @StateObject var errorHandling = ErrorHandling()
    
    let absence: Registration
    
    init(absence: Registration){
        self.absence = absence
    }
    
    var body: some View {
        HStack {
            Text(stringSeparator(reason: absence.reason.rawValue).uppercased())
                .smallBodyTextStyle(color: .white, font: .poppinsBold)
                .frame(width: 36, height: 36)
                .background(Color.frolyRed)
                .clipShape(Circle())
            
            Spacer()
            
            VStack {
                Text("Dato")
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                if let endDate = absence.endDate {
                    let dateCombined = absence.date + "\n" + endDate
                    Text(dateCombined)
                        .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
                } else {
                    Text(absence.date)
                        .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
                }
            }
            
            Spacer()
            
            VStack {
                Text("Årsag")
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                Text(absence.reason.rawValue)
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
            }
            
            Spacer()

            if absence.endDate == nil {
                Image(systemName: "ellipsis")
                    .foregroundColor(Color.fiftyfifty)
                    .padding(.trailing, 10)
            }
        }
        .fullScreenCover(item: $errorHandling.appError, content: { appError in
            ErrorView(title: appError.title, error: appError.description) {
                childrenViewModel.fetchChildren(parentID: DefaultsManager.shared.currentProfileID) { result in
                    if result {
                        childrenViewModel.attachAbsenceListeners()
                    }
                }
                childrenViewModel.attachReportListeners()
            }
        })
        .listRowBackground(Color.clear)
    }
}

struct AbsenceReportSection_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceReportSection(absence: Registration(studentID: "", studentName: "", className: "", date: "", endDate: nil, isMorning: false))
    }
}
