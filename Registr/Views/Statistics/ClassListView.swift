//
//  ClassListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 24/03/2022.
//

import SwiftUI

struct ClassListView: View {
    @EnvironmentObject var classViewModel: ClassViewModel
    @StateObject var errorHandling = ErrorHandling()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(classViewModel.classes, id: \.self) { classInfo in
                        ClassSection(classInfo: classInfo)
                    }
                    .listRowBackground(Color.frolyRed)
                    .listRowSeparatorTint(Color.white)
                }
            }
            .fullScreenCover(item: $errorHandling.appError, content: { appError in
                ErrorView(title: appError.title, error: appError.description) {
                    classViewModel.fetchClasses()
                }
            })
            .navigationTitle("cl_navigationtitle".localize)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ClassListView_Previews: PreviewProvider {
    static var previews: some View {
        ClassListView()
    }
}
