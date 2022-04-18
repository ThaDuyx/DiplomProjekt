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
                        
                    }
                }
            }
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
