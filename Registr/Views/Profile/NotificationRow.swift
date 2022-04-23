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
                Toggle("Tilladelse til at modtage notifikationer, når der er blevet registreret fravær.", isOn: $notificationVM.subscribeToNotification)
                    .darkBodyTextStyleToggle()
                    .toggleStyle(SwitchToggleStyle(tint: Resources.Color.Colors.frolyRed.opacity(0.5)))
                    .padding()
            } else {
                VStack(spacing: 0) {
                    Text("notification_title")
                        .boldDarkBodyTextStyle()
                        .padding()
                    Text("notification_description")
                        .darkBodyTextStyle()
                        .padding()
                    Link(destination: URL(string: UIApplication.openSettingsURLString)!, label: {
                        Text("notification_button_title")
                    })
                    .buttonStyle(Resources.CustomButtonStyle.FilledSmallButtonStyle())
                }
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
