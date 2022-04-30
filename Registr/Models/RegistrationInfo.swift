//
//  RegistrationInfo.swift
//  Registr
//
//  Created by Simon Andersen on 28/04/2022.
//

import Foundation

struct RegistrationInfo: Decodable, Encodable {
    var hasAfternoonBeenRegistrered: Bool = false
    var hasMorningBeenRegistrered: Bool = false
}
