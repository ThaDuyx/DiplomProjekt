//
//  NotificationViewModel.swift
//  Registr
//
//  Created by Christoffer Detlef on 22/04/2022.
//

import SwiftUI
import UserNotifications
import FirebaseMessaging

class NotificationViewModel: ObservableObject {
    @Published var isViewActive : Bool = false
    @Published var permission: UNAuthorizationStatus?
    @AppStorage("subscribeToNotification") var subscribeToNotification : Bool = false {
        didSet {
            if subscribeToNotification {
                subscribeToTopic()
            } else {
                unsubscribeFromTopic()
            }
        }
    }
    let current = UNUserNotificationCenter.current()
    
    func getNotificationSettings() {
        current.getNotificationSettings { permission in
            DispatchQueue.main.async {
                self.permission = permission.authorizationStatus
            }
            
            if permission.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
                if self.subscribeToNotification {
                    self.subscribeToTopic()
                } else {
                    self.unsubscribeFromTopic()
                }
                
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.unregisterForRemoteNotifications()
                    self.current.removeAllPendingNotificationRequests()
                    self.current.removeAllDeliveredNotifications()
                }
                
                self.unsubscribeFromTopic()
            }
        }
    }
    
    private func subscribeToTopic() {
        guard permission == .authorized else {
            return
        }
        
        Messaging.messaging().subscribe(toTopic: "topic") { error in
            if let error = error {
                print("Error while subscribing: ", error)
                return
            }
            print("Subscribed to notifications for topic")
        }
    }
    private func unsubscribeFromTopic() {
        Messaging.messaging().unsubscribe(fromTopic: "topic") { error in
            if let error = error {
                print("Error while unsubscribing: ", error)
                return
            }
            print("Unsubcribed to notifications for topic")
        }
    }
}
