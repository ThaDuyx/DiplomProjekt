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
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        UINavigationBar.appearance().isOpaque = true
        
        let tabBarAppearance = UITabBarAppearance(barAppearance: UIBarAppearance())
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Resources.Color.Colors.mediumMint)
        tabBarAppearance.shadowColor = UIColor(Resources.Color.Colors.darkBlue)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().isOpaque = true
    }
}
