//
//  RegistrAppDelegate.swift
//  Registr
//
//  Created by Christoffer Detlef on 21/04/2022.
//

import UIKit
import FirebaseMessaging
import UserNotifications
import SwiftUI

class RegistrAppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        application.registerForRemoteNotifications()
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else {
                return
            }
            print("Token: \(token)")
        }
    }
}
