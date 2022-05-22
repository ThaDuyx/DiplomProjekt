//
//  OnboardingView.swift
//  Registr
//
//  Created by Christoffer Detlef on 09/03/2022.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("currentPage") var currentPage = 1
    @AppStorage("dataAccess") var dataAccess = false
    @AppStorage("totalPages") var totalPages = 1
    
    let pages = [
        OnboardSection(
            id: 1,
            title: "onboard_flow_page_one_title",
            details: "onboard_flow_page_one_description",
            image: "bell.badge.circle.fill"
        ),
        OnboardSection(
            id: 2,
            title: "onboard_flow_page_two_title",
            details: "onboard_flow_page_two_description",
            image: "lock.icloud.fill"
        ),
        OnboardSection(
            id: 3,
            title: "onboard_flow_page_three_title",
            details: DefaultsManager.shared.userRole == .parent ? "onboard_flow_page_three_description_parent" : "onboard_flow_page_three_description_school",
            image: "iphone.circle.fill"
        ),
        OnboardSection(
            id: 4,
            title: "onboard_flow_page_four_title",
            details: "onboard_flow_page_four_description",
            image: "checkmark.shield.fill"
        )
    ]
    
    var body: some View {
        VStack {
            ForEach(pages, id: \.id) { page in
                if currentPage == page.id {
                    page
                        .overlay(
                            Button("next_view") {
                                if page.id == 1 {
                                    UNUserNotificationCenter.current().requestAuthorization(
                                        options: [.alert, .sound, .badge]) { succes, _ in
                                            guard succes else {
                                                nextPage()
                                                return
                                            }
                                            nextPage()
                                            print("Succes in APNS registry")
                                        }
                                } else {
                                    nextPage()
                                }
                            }
                                .buttonStyle(Resources.CustomButtonStyle.StandardButtonStyle(font: .poppinsSemiBold, fontSize: Resources.FontSize.primaryHeader))
                                .padding(.bottom, 20)
                            ,alignment: .bottom
                        )
                }
            }
        }
        .onAppear() {
            totalPages = pages.count
            print(totalPages)
        }
    }
    func nextPage() {
        withAnimation(.easeInOut) {
            currentPage += 1
        }
    }
}



struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
