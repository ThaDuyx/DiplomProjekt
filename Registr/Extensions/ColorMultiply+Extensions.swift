//
//  ColorMultiply+Extensions.swift
//  Registr
//
//  Created by Christoffer Detlef on 31/03/2022.
//

import SwiftUI

extension View {
  @ViewBuilder func applyTextColor(_ color: Color) -> some View {
    if UITraitCollection.current.userInterfaceStyle == .light {
      self.colorInvert().colorMultiply(color)
    } else {
      self.colorMultiply(color)
    }
  }
}
