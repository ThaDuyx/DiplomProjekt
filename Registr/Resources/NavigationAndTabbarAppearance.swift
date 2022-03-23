//
//  NavigationAndTabbarAppearance.swift
//  Registr
//
//  Created by Christoffer Detlef on 16/03/2022.
//


import UIKit

struct NavigationAndTabbarAppearance {
    static func configureAppearance() {
        let navigationAppearance = UINavigationBarAppearance(barAppearance: UIBarAppearance())
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = UIColor(Resources.Color.Colors.lightMint)
        navigationAppearance.shadowColor = UIColor.clear
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        if #available(iOS 15.0, *) {
            UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        }
        UINavigationBar.appearance().backgroundColor = UIColor(Resources.Color.Colors.lightMint)
        UINavigationBar.appearance().isOpaque = true
        
        let tabBarAppearance = UITabBarAppearance(barAppearance: UIBarAppearance())
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Resources.Color.Colors.mediumMint)
        tabBarAppearance.shadowColor = UIColor.clear
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        UITabBar.appearance().backgroundColor = UIColor(Resources.Color.Colors.mediumMint)
        UITabBar.appearance().isOpaque = true
    }
}
