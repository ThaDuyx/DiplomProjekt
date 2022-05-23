//
//  ReportStateSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 23/05/2022.
//

import SwiftUI
import RiveRuntime

enum AnimationStates: String {
    case error = "Error"
    case check = "Check"
}

struct ReportStateSection: View {
    @State private var description: String = ""
    @State var remaining = 3.0
    @Environment(\.presentationMode) var mode
    
    let state: String
    var stateChanger = RiveViewModel(fileName: "check", stateMachineName: "State Machine 1")

    var body: some View {
        ZStack {
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
            VStack {
                stateChanger.view()
                    .frame(height:200)
                Text(description)
                    .subTitleTextStyle(color: .white, font: .poppinsRegular)
            }
        }
        .onAppear() {
            try? stateChanger.setInput(state, value: true)
            if state == AnimationStates.check.rawValue {
                description = "Indberettelsen er blevet oprettede."
            } else {
                description = "Der er sket en fejl. Prøv igen!"
            }
        }
        .onReceive(Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()) { _ in
            self.remaining -= 0.01
            if self.remaining <= 0 {
                self.mode.wrappedValue.dismiss()
            }
        }
    }
}

struct ReportStateSection_Previews: PreviewProvider {
    static var previews: some View {
        ReportStateSection(state: "Check")
    }
}
