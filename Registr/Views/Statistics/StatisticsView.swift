//
//  StatisticsView.swift
//  Registr
//
//  Created by Christoffer Detlef on 24/03/2022.
//

import SwiftUI

struct StatisticsView: View {
    let className: String
    
    init(className: String) {
        self.className = className
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Resources.BackgroundGradient.backgroundGradient
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        HStack {
                            Image(systemName: "star")
                                .foregroundColor(Resources.Color.Colors.darkPurple)
                            Text("Følger ikke")
                                .boldSubTitleTextStyle()
                        }
                        .padding()
                    }
                    .padding(.trailing, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding(4)
                    Spacer()
                    VStack {
                        Button {
                            print("Historik have been pressed")
                        } label: {
                            HStack {
                                Image(systemName: "star")
                                Text("Historik")
                            }
                        }
                        .buttonStyle(Resources.CustomButtonStyle.FilledButtonStyle())
                        Button {
                            print("Elever have been pressed")
                        } label: {
                            HStack {
                                Image(systemName: "person.3")
                                Text("Elever")
                            }
                        }
                        .buttonStyle(Resources.CustomButtonStyle.FilledButtonStyle())
                    }
                    
                }
            }
            .navigationTitle(className)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(className: "ClassName")
    }
}
