//
//  ClassListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 24/03/2022.
//

import SwiftUI

struct ClassListView: View {
    @EnvironmentObject var registrationManager: RegistrationManager
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(registrationManager.classes, id: \.self) { classInfo in
                        ClassEntity(classInfo: classInfo)
                    }
                    .listRowBackground(Resources.Color.Colors.frolyRed)
                    .listRowSeparatorTint(Resources.Color.Colors.white)
                }
            }
            .navigationTitle("Statistik")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ClassEntity: View {
    let classInfo: ClassInfo
    
    var body: some View {
        HStack {
            Text(classInfo.name)
                .boldBodyTextStyle()
                .frame(maxWidth: .infinity, alignment: .center)
            
            NavigationLink(destination: ClassView(classInfo: classInfo)) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            
            Image(systemName: "chevron.right")
                .foregroundColor(Resources.Color.Colors.white)
                .padding(.trailing, 10)
        }
        .frame(height: 35)
    }
}

struct ClassListView_Previews: PreviewProvider {
    static var previews: some View {
        ClassListView()
    }
}
