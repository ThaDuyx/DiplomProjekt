//
//  Color.swift
//  Registr
//
//  Created by Christoffer Detlef on 02/03/2022.
//

import SwiftUI

extension Resources {
    enum Color {}
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

private class BundleClass {}

extension Resources.Color {
    struct Colors {
        static var darkPurple = Color(hex: 0x272643)
        static var white = Color(hex: 0xFFFFFF)
        static var lightMint = Color(hex: 0xE3F6F5)
        static var mediumMint = Color(hex: 0xBAE8E8)
        static var darkBlue = Color(hex: 0x2C698D)
        static var bloodRed = Color(hex: 0xCA6161)
    }
}
