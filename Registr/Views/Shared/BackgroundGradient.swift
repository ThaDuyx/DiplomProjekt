//
//  BackgroundGradient.swift
//  Registr
//
//  Created by Christoffer Detlef on 02/03/2022.
//

import SwiftUI

extension Resources {
    struct BackgroundGradient {
        static var backgroundGradient = LinearGradient(
            colors: [Resources.Color.Colors.lightMint, Resources.Color.Colors.mediumMint],
            startPoint: .top, endPoint: .bottom)
    }
}
