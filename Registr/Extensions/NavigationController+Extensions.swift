//
//  NavigationController+Extensions.swift
//  Registr
//
//  Created by Christoffer Detlef on 13/04/2022.
//

import SwiftUI

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
