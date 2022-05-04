//
//  AbsenceReportSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import SwiftUI

struct AbsenceReportSection: View {
    @EnvironmentObject var childrenManager: ChildrenManager
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
                Text(absence.date)
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
            }
            
            Spacer()
            
            VStack {
                Text("Årsag")
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                Text(absence.reason.rawValue)
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
            }
            
            Spacer()

            Image(systemName: "ellipsis")
                .foregroundColor(Color.fiftyfifty)
                .padding(.trailing, 10)
        }
        .fullScreenCover(item: $errorHandling.appError, content: { appError in
            ErrorView(title: appError.title, error: appError.description) {
                childrenManager.fetchChildren(parentID: DefaultsManager.shared.currentProfileID) { result in
                    if result {
                        childrenManager.attachAbsenceListeners()
                    }
                }
                childrenManager.attachReportListeners()
            }
        })
        .listRowBackground(Color.clear)
    }
}

struct AbsenceReportSection_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceReportSection(absence: Registration(studentID: "", studentName: "", className: "", date: "", isMorning: false))
    }
}
