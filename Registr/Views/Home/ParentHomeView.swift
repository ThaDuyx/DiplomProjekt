//
//  ParentHomeView.swift
//  Registr
//
//  Created by Christoffer Detlef on 18/04/2022.
//

import SwiftUI

struct ParentHomeView: View {
    @EnvironmentObject var childrenViewModel: ChildrenViewModel
    @EnvironmentObject var notificationVM: NotificationViewModel
    @StateObject var errorHandling = ErrorHandling()

    var body: some View {
        NavigationView {
            ZStack {
                if childrenViewModel.children.isEmpty {
                    Text("Du har ikke registeret nogle børn. Hvis dette er en fejl, så søg kontakt hos skolen.")
                        .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                        .multilineTextAlignment(.leading)
                        .frame(width: 320)
                } else {
                    List {
                        ForEach(childrenViewModel.children, id: \.self) { child in
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 65, height: 65)
                                    .foregroundColor(.white)
                                    .padding()
                                
                                Divider()
                                    .frame(width: 2)
                                    .background(.white)
                                
                                VStack(spacing: 13) {
                                    Text("Navn: \(child.name)")
                                        .smallBodyTextStyle(color: .white, font: .poppinsBold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("Klasse: \(child.className)")
                                        .smallBodyTextStyle(color: .white, font: .poppinsBold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("Email: \(child.email)")
                                        .smallBodyTextStyle(color: .white, font: .poppinsBold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                if let id = child.id {
                                    NavigationLink(destination: StudentView(studentName: child.name, isParent: true, studentID: id, student: child)) {
                                        EmptyView()
                                    }
                                    .frame(width: 0, height: 0)
                                    .environmentObject(childrenViewModel)
                                }
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.white)
                                    .padding(.trailing, 10)
                            }
                        }
                        .listRowBackground(Color.frolyRed)
                        .listRowSeparatorTint(Color.white)
                        .onAppear() {
                            if !notificationVM.parentSubscribeToNotification {
                                notificationVM.parentSubscribeToNotification = true
                            }
                        }
                    }
                }
            }
            .onAppear() {
                notificationVM.getNotificationSettings()
            }
            .fullScreenCover(item: $errorHandling.appError, content: { appError in
                ErrorView(title: appError.title, error: appError.description) {
                    childrenViewModel.fetchChildren(parentID: DefaultsManager.shared.currentProfileID) { result in
                        if result {
                            childrenViewModel.attachAbsenceListeners()
                        }
                    }
                    childrenViewModel.attachReportListeners()
                }
            })
            .navigationTitle("Børn")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ParentHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ParentHomeView()
    }
}
