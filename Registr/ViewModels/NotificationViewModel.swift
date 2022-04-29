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
    @AppStorage("nameOfSubscriptions") var nameOfSubscriptions: String = ""
    @AppStorage("subscribeToNotification") var subscribeToNotification : Bool = false {
        didSet {
            updateSubscription(for: nameOfSubscriptions, subscribed: subscribeToNotification)
        }
    }
    @AppStorage("teacherSubscribeToNotification") var teacherSubscribeToNotification : Bool = false {
        didSet {
            teacherUpdateSubscription(subscribed: teacherSubscribeToNotification)
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
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.unregisterForRemoteNotifications()
                    self.current.removeAllPendingNotificationRequests()
                    self.current.removeAllDeliveredNotifications()
                }
            }
        }
    }
    
    private func teacherUpdateSubscription(subscribed: Bool) {
        if subscribed {
            for topics in DefaultsManager.shared.favorites {
                print("subscribing to \(topics)")
                subscribe(to: topics)
            }
        } else {
            for topics in DefaultsManager.shared.favorites {
                print("unsubscribing to \(topics)")
                unsubscribe(from: topics)
            }
        }
    }
    
    private func updateSubscription(for topic: String, subscribed: Bool) {
      if subscribed {
          
        subscribe(to: topic)
      } else {
        unsubscribe(from: topic)
      }
    }
    
    func subscribe(to topic: String) {
        guard permission == .authorized else {
            return
        }
        
        Messaging.messaging().subscribe(toTopic: topic) { error in
            if let error = error {
                print("Error while subscribing: ", error)
                return
            }
            print("Subscribed to notifications from: \(topic)")
        }
    }
    func unsubscribe(from topic: String) {
        Messaging.messaging().unsubscribe(fromTopic: topic) { error in
            if let error = error {
                print("Error while unsubscribing: ", error)
                return
            }
            print("Unsubcribed to notifications from: \(topic)")
        }
    }
}
