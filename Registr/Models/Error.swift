//
//  Error.swift
//  Registr
//
//  Created by Christoffer Detlef on 02/05/2022.
//

import Foundation

enum RegistrError: Error, LocalizedError {
    case registrationManagerError
    case statisticsManagerError
}

struct ErrorType: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let type: RegistrError?
}
