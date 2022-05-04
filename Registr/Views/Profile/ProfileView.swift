//
//  ProfileView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI
import SwiftUIKit

struct ProfileView: View {
    @EnvironmentObject var notificationVM: NotificationViewModel
    @StateObject private var context = FullScreenCoverContext()
    let isTeacher: Bool
    var body: some View {
        VStack {
            NotificationRow(isTeacher: isTeacher)
                .padding(.top, 20)
            Spacer()
            Button {
                logOut()
            } label: {
                Text("Log ud")
            }
            .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsSemiBold, fontSize: Resources.FontSize.primaryHeader))
            Text("app_info")
                .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding()
        }
        .fullScreenCover(context)
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension ProfileView {
    private func logOut() {
        AuthenticationManager.shared.signOut { status in
            if status {
                if UserManager.shared.user?.role == .parent {
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
                context.present(ErrorView(title: "alert_title".localize, error: "alert_default_description".localize))
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isTeacher: true)
    }
}
