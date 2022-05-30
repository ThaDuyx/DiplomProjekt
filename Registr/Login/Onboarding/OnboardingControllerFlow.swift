//
//  OnboardingControllerFlow.swift
//  Registr
//
//  Created by Christoffer Detlef on 09/03/2022.
//

import SwiftUI

struct OnboardingControllerFlow: View {
    @AppStorage("currentPage") var currentPage = 1
    @AppStorage("totalPages") var totalPages = 1

    var body: some View {
        if currentPage > totalPages {
            TabViews()
        } else {
            OnboardingView()
        }
    }
}

struct OnboardingControllerFlow_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingControllerFlow()
    }
}
