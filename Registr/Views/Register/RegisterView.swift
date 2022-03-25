//
//  RegisterView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI

struct RegisterView: View {
    
    init() {
        // To make the List background transparent, so the gradient background can be used.
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Resources.BackgroundGradient.backgroundGradient
                    .ignoresSafeArea()
                Form {
                    Section(
                        header:
                            HStack {
                                Image(systemName: "star")
                                Text("Placeholder text - favorites")
                            }
                    ) {
                        ClassStack()
                        ClassStack()
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    Section(
                        header:
                            HStack {
                                Image(systemName: "person.3")
                                Text("Placeholder text - Class")
                            }
                    ) {
                        ClassStack()
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .navigationTitle("Registrer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ClassStack: View {
    var body: some View {
        NavigationLink(destination: StudentClassListView()) {
            VStack {
                HStack {
                    Image(systemName: "star")
                        .frame(alignment: .leading)
                        .foregroundColor(.black)
                    Text("0.X")
                        .darkBodyTextStyle()
                        .frame(maxWidth: .infinity, alignment: .center)
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                        .frame(alignment: .trailing)
                        .onTapGesture {
                            print("Hello world")
                        }
                }
                .padding()
            }
        }
        .padding(.trailing, 20)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 1)
        )
        .padding(4)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
