//
//  ParentHomeView.swift
//  Registr
//
//  Created by Christoffer Detlef on 18/04/2022.
//

import SwiftUI

struct ParentHomeView: View {
    @EnvironmentObject var childrenManager: ChildrenManager

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(childrenManager.children, id: \.self) { child in
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
                                    .boldSmallBodyTextStyle()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("Klasse: \(child.className)")
                                    .boldSmallBodyTextStyle()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("Email: \(child.email)")
                                    .boldSmallBodyTextStyle()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            if let id = child.id {
                                NavigationLink(destination: StudentView(studentName: child.name, isParent: true, studentID: id)) {
                                    EmptyView()
                                }
                                .frame(width: 0, height: 0)
                            }
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Resources.Color.Colors.white)
                                .padding(.trailing, 10)
                        }
                    }
                    .listRowBackground(Resources.Color.Colors.frolyRed)
                    .listRowSeparatorTint(Resources.Color.Colors.white)
                }
            }
            .navigationTitle("Børn")
            .navigationBarTitleDisplayMode(.inline)
            .navigationAppearance(backgroundColor: .white)
        }
    }
}

struct ParentHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ParentHomeView()
    }
}
