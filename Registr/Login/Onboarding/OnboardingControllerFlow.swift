//
//  OnboardingControllerFlow.swift
//  Registr
//
//  Created by Christoffer Detlef on 09/03/2022.
//

import SwiftUI

struct OnboardingControllerFlow: View {
    @AppStorage("currentPage") var currentPage = 1

    var body: some View {
        if currentPage > 3 {
            TabViews()
        } else {
            OnboardingFlowControllerView()
        }
    }
}

struct OnboardingControllerFlow_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingControllerFlow()
    }
}
