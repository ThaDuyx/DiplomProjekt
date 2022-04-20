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
        navigationAppearance.backgroundColor = UIColor.clear
        navigationAppearance.shadowColor = UIColor.clear

        navigationAppearance.titleTextAttributes = [
            // It is okay to force unwrap, since we have imported the font into the project - CAD
            .font: UIFont(name: "Poppins-Regular", size: 20)!,
            .foregroundColor: UIColor(Resources.Color.Colors.fiftyfifty)
        ]

        UINavigationBar.appearance().tintColor = UIColor(Resources.Color.Colors.frolyRed)
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        UINavigationBar.appearance().isOpaque = true
        
        let tabBarAppearance = UITabBarAppearance(barAppearance: UIBarAppearance())
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Resources.Color.Colors.white)
        tabBarAppearance.shadowColor = UIColor.clear
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().isOpaque = true
        
        UITableView.appearance().backgroundColor = .white
    }
}
