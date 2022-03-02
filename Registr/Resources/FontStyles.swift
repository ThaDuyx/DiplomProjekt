//
//  FontStyles.swift
//  Registr
//
//  Created by Christoffer Detlef on 02/03/2022.
//

import SwiftUI

extension Text {
    func bigHeaderTextStyle() -> some View {
        self.foregroundColor(Resources.Color.Colors.darkPurple)
            .font(.system(size: Resources.FontSize.bigHeader))
    }
}
