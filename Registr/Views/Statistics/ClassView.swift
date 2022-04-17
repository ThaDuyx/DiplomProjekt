//
//  ClassView.swift
//  Registr
//
//  Created by Christoffer Detlef on 17/04/2022.
//

import SwiftUI

struct ClassView: View {
    let className: String
    @State private var followAction: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Button {
                    followAction.toggle()
                } label: {
                    HStack {
                        Image(systemName: "checkmark.diamond")
                        Text(followAction ? "Følger" : "Følger ikke")
                    }
                }
                .buttonStyle(Resources.CustomButtonStyle.TransparentFollowButtonStyle())
            }
        }
        .navigationTitle(className)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ClassView_Previews: PreviewProvider {
    static var previews: some View {
        ClassView(className: "0.X")
    }
}
