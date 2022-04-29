//
//  NotificationItem.swift
//  Registr
//
//  Created by Christoffer Detlef on 28/04/2022.
//

import Foundation

struct NotificationItem: Identifiable, Codable {
  var id = UUID()
  let title: String
  let body: String
  let date: Date

  private enum CodingKeys: String, CodingKey {
    case title
    case body
    case date
  }
}
