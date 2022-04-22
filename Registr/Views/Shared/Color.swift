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
        /// Hexcode is FFFFFF
        static var white = Color(hex: 0xFFFFFF)
        /// Hexcode is e2e0d4
        static var moonMist = Color(hex: 0xe2e0d4)
        /// Hexcode is f97c7c
        static var frolyRed = Color(hex: 0xf97c7c)
        /// Hexcode is 505050
        static var fiftyfifty = Color(hex: 0x505050)
    }
}
