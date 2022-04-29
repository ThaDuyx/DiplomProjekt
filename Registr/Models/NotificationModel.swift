//
//  NotificationModel.swift
//  Registr
//
//  Created by Christoffer Detlef on 28/04/2022.
//

import Foundation

class NotificationModel: ObservableObject {
  @Published private(set) var notificationItem: [NotificationItem] = []

  func add(_ items: [NotificationItem]) {
    var tempItems = notificationItem
    tempItems.append(contentsOf: items)
      notificationItem = tempItems.sorted {
      $0.date > $1.date
    }
  }
}

extension NotificationModel {
  static let shared = mockModel()
  private static func mockModel() -> NotificationModel {
    let notificationModel = NotificationModel()
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    guard
      let url = Bundle.main.url(forResource: "MockNotificationItems", withExtension: "json"),
      let data = try? Data(contentsOf: url),
      let notificationItem = try? decoder.decode([NotificationItem].self, from: data)
    else {
      return notificationModel
    }
      notificationModel.add(notificationItem)
    return notificationModel
  }
}
