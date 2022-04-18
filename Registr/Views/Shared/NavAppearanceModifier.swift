//
//  NavAppearanceModifier.swift
//  Registr
//
//  Created by Christoffer Detlef on 17/04/2022.
//

import SwiftUI

struct NavAppearanceModifier: ViewModifier {
    init(backgroundColor: UIColor) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = backgroundColor
        navBarAppearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func navigationAppearance(backgroundColor: UIColor) -> some View {
        self.modifier(NavAppearanceModifier(backgroundColor: backgroundColor))
    }
}
