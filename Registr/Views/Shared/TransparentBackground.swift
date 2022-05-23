//
//  TransparentBackground.swift
//  Registr
//
//  Created by Christoffer Detlef on 23/05/2022.
//

import SwiftUI

struct TransparentBackground: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
