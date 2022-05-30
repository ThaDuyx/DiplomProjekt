//
//  ProfileView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var notificationVM: NotificationViewModel
    @State private var isPresented = false
    let isTeacher: Bool
    var body: some View {
        VStack {
            NotificationRow(isTeacher: isTeacher)
                .padding(.top, 20)
            Spacer()
            Button {
                logOut()
            } label: {
                Text("profile_log_out".localize)
            }
            .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsSemiBold, fontSize: Resources.FontSize.primaryHeader))
            Text("app_info")
                .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding()
        }
        .fullScreenCover(isPresented: $isPresented, content: {
            ErrorView(title: "alert_title".localize, error: "alert_default_description".localize)
        })
        .navigationTitle("profile_navigationtitle".localize)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension ProfileView {
    private func logOut() {
        AuthenticationManager.shared.signOut { status in
            if status {
                if DefaultsManager.shared.userRole == .parent {
                    notificationVM.parentSubscribeToNotification = false
                } else {
                    notificationVM.teacherSubscribeToNotification = false
                }
                
                let window = UIApplication
                    .shared
                    .connectedScenes
                    .flatMap{( $0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }
                window?.rootViewController = UIHostingController(rootView: LoginOptions().environmentObject(notificationVM))
            } else {
                isPresented.toggle()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isTeacher: true)
    }
}
