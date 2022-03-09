//
//  OnboardingFlowControllerView.swift
//  Registr
//
//  Created by Christoffer Detlef on 09/03/2022.
//

import SwiftUI

struct PurchaseDetail: Identifiable {
    var id: Int
    let trackingId: String
    let numberOfItems: String
}

struct OnboardingFlowControllerView: View {
    @AppStorage("currentPage") var currentPage = 1
    @State private var isShowingDetailView = false
    @State private var buttonText: String = ""
    @State private var purchaseDetail: PurchaseDetail?

    private var alertTitle: String = ""
    private var alertMessage: String = ""

    
    let pages = [
        OnboardFlowView(id: 1, title: "onboard_flow_page_one_title", details: "onboard_flow_page_one_description", image: "checkmark.shield.fill", buttonText: "onboard_flow_page_one_button_text"),
        OnboardFlowView(id: 2, title: "onboard_flow_page_two_title", details: "onboard_flow_page_one_description", image: "bell.fill", buttonText: "onboard_flow_page_two_button_text"),
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
                                        purchaseDetail = PurchaseDetail(
                                            id: 1,
                                            trackingId: "alert 1",
                                            numberOfItems: "alert 1"
                                        )
                                    } else if currentPage == 2 {
                                        purchaseDetail = PurchaseDetail(
                                            id: 2,
                                            trackingId: "alert 2",
                                            numberOfItems: "alert 2"
                                        )
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
        .alert(item: $purchaseDetail, content: { content in
            Alert(
                title: Text(content.trackingId),
                message: Text(content.numberOfItems),
                primaryButton: .default(Text("Okay"), action: {
                    currentPage += 1
                }), secondaryButton: .cancel(Text("Cancel"), action: {
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
