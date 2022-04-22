//
//  NotificationRow.swift
//  Registr
//
//  Created by Christoffer Detlef on 22/04/2022.
//

import SwiftUI

struct NotificationRow: View {
    @EnvironmentObject var notificationVM: NotificationViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        Group {
            if notificationVM.permission == .authorized {
                Toggle("Show welcome message", isOn: $notificationVM.subscribeToNotification)
            } else {
                Text("Hello World")
            }
        }
        .onChange(of: notificationVM.isViewActive, perform: { phase in
            print("The phase is: \(phase)")
            if phase {
                notificationVM.getNotificationSettings()
            }
        })
        .onAppear() {
            notificationVM.getNotificationSettings()
        }
    }
}

struct NotificationRow_Previews: PreviewProvider {
    static var previews: some View {
        NotificationRow()
    }
}
