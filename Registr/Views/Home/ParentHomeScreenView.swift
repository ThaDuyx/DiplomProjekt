//
//  ParentHomeScreenView.swift
//  Registr
//
//  Created by Christoffer Detlef on 11/03/2022.
//

import SwiftUI

struct ParentHomeScreenView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Resources.BackgroundGradient.backgroundGradient
                    .ignoresSafeArea()
                Form {
                    Section {
                        CardStack()
                    }
                }
            }
            .navigationTitle("Dine børn")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CardStack: View {
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    VStack {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 80, height: 80)
                    }
                    .frame(width: 90, height: 100)
                    .background(Color.red)
                    Spacer()
                }
                .foregroundColor(Color.blue)
                .frame(alignment: .leading)
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("Navn:")
                            Text("Simon Andersen")
                        }
                        VStack(alignment: .leading) {
                            Text("Klasse:")
                            Text("8.Y")
                        }
                        VStack(alignment: .leading) {
                            Text("Email:")
                            Text("Email@email.dk")
                        }
                    }
                }
                .frame(alignment: .center)
            }
        }
    }
}

struct ParentHomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ParentHomeScreenView()
    }
}
