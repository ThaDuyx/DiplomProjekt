//
//  OnboardingFlowControllerView.swift
//  Registr
//
//  Created by Christoffer Detlef on 09/03/2022.
//

import SwiftUI

struct AlertDetail: Identifiable {
    var id: Int
    let alertTitle: String
    let alertMessage: String
}

struct OnboardingFlowControllerView: View {
    @AppStorage("currentPage") var currentPage = 1
    @AppStorage("dataAccess") var dataAccess = false
    @State private var isShowingDetailView = false
    @State private var buttonText: String = ""
    @State private var alertDetail: AlertDetail?

    private var alertTitle: String = ""
    private var alertMessage: String = ""

    
    let pages = [
        OnboardFlowView(id: 1, title: "onboard_flow_page_one_title", details: "onboard_flow_page_one_description", image: "checkmark.shield.fill", buttonText: "onboard_flow_page_one_button_text"),
        OnboardFlowView(id: 2, title: "onboard_flow_page_two_title", details: "onboard_flow_page_two_description", image: "bell.fill", buttonText: "onboard_flow_page_two_button_text"),
        OnboardFlowView(id: 3, title: "onboard_flow_page_three_title", details: "onboard_flow_page_three_description", image: "checklist", buttonText: "onboard_flow_page_three_button_text")
    ]
    
    var body: some View {
        let totalPages = pages.count
        VStack {
            ForEach(pages, id: \.id) { page in
                if currentPage == page.id {
                    page
                }
            }
            .overlay(
                ForEach(pages, id: \.id) { page in
                    if currentPage == page.id {
                        Button(page.buttonText.localize) {
                            withAnimation(.easeInOut) {
                                if currentPage <= totalPages {
                                    if currentPage == 1 {
                                        alertDetail = AlertDetail(
                                            id: 1,
                                            alertTitle: "Adgang til din data",
                                            alertMessage: "Giv appen lov til at tilgå data om dig."
                                        )
                                    } else if currentPage == 2 {
                                        UNUserNotificationCenter.current().requestAuthorization(
                                            options: [.alert, .sound, .badge]) { succes, _ in
                                                guard succes else {
                                                    currentPage += 1
                                                    return
                                                }
                                                currentPage += 1
                                                print("Succes in APNS registry")
                                            }
                                    } else {
                                        currentPage += 1
                                    }
                                }
                            }
                        }
                    }
                }
                    .buttonStyle(Resources.CustomButtonStyle.SmallFrontPageButtonStyle())
                    .padding(.bottom, 20)
                ,alignment: .bottom
            )
        }
        .alert(item: $alertDetail, content: { content in
            Alert(
                title: Text((content.alertTitle).localize),
                message: Text((content.alertMessage.localize).localize),
                primaryButton: .default(Text("Godkend"), action: {
                    if currentPage == 1 {
                        dataAccess = true
                    }
                    currentPage += 1
                }), secondaryButton: .cancel(Text("Ikke godkendt"), action: {
                    currentPage += 1
                })
            )
        })
    }
}

struct OnboardingFlowControllerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFlowControllerView()
    }
}
