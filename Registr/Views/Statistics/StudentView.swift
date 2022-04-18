//
//  StudentView.swift
//  Registr
//
//  Created by Christoffer Detlef on 17/04/2022.
//

import SwiftUI
import SwiftUICharts

struct StudentView: View {
    
    // This is for testing the chart
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    let studentName: String

    var body: some View {
        VStack {
            VStack {
                PieChart()
                    .data(demoData)
                    .chartStyle(ChartStyle(backgroundColor: .white,
                                           foregroundColor: ColorGradient(Resources.Color.Colors.fiftyfifty, Resources.Color.Colors.fiftyfifty)))
            }
            .frame(width: 150, height: 150)
            
            VStack(alignment: .leading, spacing: -10) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(Resources.Color.Colors.fiftyfifty)
                    Text("Statistik")
                        .boldDarkBodyTextStyle()
                        .padding(.leading, 20)
                }
                VStack(alignment: .center, spacing: 15) {
                    
                    Text("4.52% fraværsprocent")
                        .lightBodyTextStyle()
                        .padding(.top, 10)
                    
                    Text("2.54% lovligt fravær")
                        .lightBodyTextStyle()
                    
                    Text("7.14% ulovligt fravær")
                        .lightBodyTextStyle()
                    
                    Text("67 gange forsent")
                        .lightBodyTextStyle()
                        .padding(.bottom, 10)
                    
                }
                .frame(width: 290)
                .background(Resources.Color.Colors.frolyRed)
                .cornerRadius(20)
                .padding()
            }
            Spacer()
        }
        .navigationTitle(studentName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StudentView_Previews: PreviewProvider {
    static var previews: some View {
        StudentView(studentName: "")
    }
}
