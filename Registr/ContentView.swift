//
//  ContentView.swift
//  Registr
//
//  Created by Simon Andersen on 02/03/2022.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("application_name")
                .padding()

            Button("application_name") {
                AuthenticationManager.shared.signIn(email: "test@test.com", password: "test1234", type: .parent)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
