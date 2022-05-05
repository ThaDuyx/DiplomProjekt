//
//  Error.swift
//  Registr
//
//  Created by Christoffer Detlef on 02/05/2022.
//

import Foundation

enum RegistrError: Error, LocalizedError {
    case registrationManagerError
    case registrationManagerInitError
    case statisticsManagerError
    case reportManagerError
    case reportMangerInitError
    case childrenManagerError
    case childrenManagerDeleteError
    case schoolManagerError
    case classManagerError
}

struct ErrorType: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let type: RegistrError
}

class ErrorHandling: ObservableObject {
    static let shared = ErrorHandling()
    
    // Object for the ErrorType, used to present an error view.
    @Published var appError: ErrorType? = nil
}
