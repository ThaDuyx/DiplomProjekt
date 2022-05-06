//
//  NavigationAndTabbarAppearance.swift
//  Registr
//
//  Created by Christoffer Detlef on 16/03/2022.
//


import UIKit
import SwiftUI

struct NavigationAndTabbarAppearance {
    static func configureAppearance(clear: Bool) {
        let navigationAppearance = UINavigationBarAppearance(barAppearance: UIBarAppearance())
        if clear {
            navigationAppearance.configureWithTransparentBackground()
            navigationAppearance.backgroundColor = UIColor.clear
        } else {
            navigationAppearance.configureWithDefaultBackground()
            navigationAppearance.backgroundColor = UIColor.white
        }
        navigationAppearance.shadowColor = UIColor.clear

        navigationAppearance.titleTextAttributes = [
            // It is okay to force unwrap, since we have imported the font into the project - CAD
            .font: UIFont(name: .poppinsRegular, size: 20)!,
            .foregroundColor: UIColor(Color.fiftyfifty)
        ]

        UINavigationBar.appearance().tintColor = UIColor(.frolyRed)
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        UINavigationBar.appearance().isOpaque = false
        
        let tabBarAppearance = UITabBarAppearance(barAppearance: UIBarAppearance())
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.white)
        tabBarAppearance.shadowColor = UIColor.clear
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().isOpaque = true
        
        UITableView.appearance().backgroundColor = .white
    }
}
