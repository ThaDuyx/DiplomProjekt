//
//  ReportStateSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 23/05/2022.
//

import SwiftUI
import RiveRuntime

struct ReportStateSection: View {
    @State private var description: String = ""
    
    let state: String
    var stateChanger = RiveViewModel(
        fileName: "check",
        stateMachineName: "State Machine 1"
    )

    var body: some View {
        ZStack {
            VStack {
                stateChanger.view()
                    .frame(height:200)
                Text(description)
                    .subTitleTextStyle(color: Color.fiftyfifty, font: .poppinsRegular)
            }
        }
        .onAppear() {
            try? stateChanger.setInput(state, value: true)
            if state == AnimationStates.check.rawValue {
                description = "rss_check_description".localize
            } else {
                description = "rss_error_description".localize
            }
        }
    }
}

struct ReportStateSection_Previews: PreviewProvider {
    static var previews: some View {
        ReportStateSection(state: "Check")
    }
}
