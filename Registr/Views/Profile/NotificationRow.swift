//
//  NotificationRow.swift
//  Registr
//
//  Created by Christoffer Detlef on 22/04/2022.
//

import SwiftUI

struct NotificationRow: View {
    let isTeacher: Bool
    @EnvironmentObject var notificationVM: NotificationViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        Group {
            if notificationVM.permission == .authorized {
                Toggle("Tilladelse til at modtage notifikationer, når der sker noget vigtigt.", isOn: isTeacher ? $notificationVM.teacherSubscribeToNotification : $notificationVM.parentSubscribeToNotification)
                    .textStyleToggle(color: .fiftyfifty, font: .poppinsRegular, size: Resources.FontSize.body)
                    .toggleStyle(SwitchToggleStyle(tint: .frolyRed.opacity(0.5)))
                    .padding()
            } else {
                VStack(spacing: 0) {
                    Text("notification_title")
                        .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                        .padding()
                    Text("notification_description")
                        .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                        .padding()
                    Link(destination: URL(string: UIApplication.openSettingsURLString)!, label: {
                        Text("notification_button_title")
                    })
                        .buttonStyle(Resources.CustomButtonStyle.SmallFilledButtonStyle())
                }
            }
        }
        .onChange(of: notificationVM.isViewActive, perform: { phase in
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
        NotificationRow(isTeacher: true)
    }
}
