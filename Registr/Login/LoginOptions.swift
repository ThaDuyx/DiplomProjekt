//  LoginOptions.swift
//  Registr
//
//  Created by Christoffer Detlef on 02/03/2022.
//

import SwiftUI
import SafariServices

/// Authorization result
enum AuthenticationResult
{
    /// User cancel flow.
    case cancel

    /// Login success.
    case success

    /// Login error.
    case error( Error )
}

typealias CompletionHandler = (_ result: AuthenticationResult ) -> Void


struct LoginOptions: View {
    @State private var showSafari = false
    @State var _completionHandler: CompletionHandler?
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
                    LogoSection(isOnboarding: false)
                    
                    Spacer()
                    
                    VStack(spacing: 40) {
                        NavigationLink(destination: UserIDView(username: "test@test.com")) {
                            Text("parent_login")
                        }.simultaneousGesture(TapGesture().onEnded{
                            AuthenticationManager.shared.loginSelection = .parent
                        })
                            .buttonStyle(Resources.CustomButtonStyle.LoginOptionsButtonStyle())
                            .accessibilityIdentifier("parentNavigationLink")
                        NavigationLink(destination: UserIDView(username: "teacher@test.com")) {
                            Text("school_login")
                        }.simultaneousGesture(TapGesture().onEnded{
                            AuthenticationManager.shared.loginSelection = .school
                        })
                            .buttonStyle(Resources.CustomButtonStyle.LoginOptionsButtonStyle())
                            .accessibilityIdentifier("teacherNavigationLink")
                        Button(action: {
                            showSafari = true
                        }, label: {
                            Text("MitID")
                        })
                        .buttonStyle(Resources.CustomButtonStyle.LoginOptionsButtonStyle())
                        Spacer()
                    }
                    .offset(y: 80)
                    .fullScreenCover(isPresented: $showSafari, content: {
                        SFSafariView(url: URL(string: "https://registr-test.criipto.id/oauth2/authorize?scope=openid&client_id=urn:my:application:identifier:1430&redirect_uri=https://jwt.io/&response_type=id_token&response_mode=fragment&nonce=ecnon-23825ad2-c9e8-441b-8633-fef700dd3e28&login_hint=acr_values:urn:grn:authn:dk:nemid:poces")!)
                    })
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear() {
            NavigationAndTabbarAppearance.configureAppearance(clear: true)
        }
    }
}

struct LoginOptions_Previews: PreviewProvider {
    static var previews: some View {
        LoginOptions()
    }
}
