//
//  StatisticsView.swift
//  Registr
//
//  Created by Christoffer Detlef on 24/03/2022.
//

import SwiftUI
import SwiftUICharts

struct StatisticsView: View {
    let className: String
    var isStudentPresented: Bool
    // This is for testing the chart
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    init(className: String, isStudentPresented: Bool) {
        self.className = className
        self.isStudentPresented = isStudentPresented
    }
    
    var body: some View {
        ZStack {
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            VStack {
                VStack {
                    HStack {
                        isStudentPresented ? nil : Image(systemName: "star")
                            .foregroundColor(Resources.Color.Colors.darkPurple)
                        Text(isStudentPresented ? className : "Følger ikke")
                            .boldSubTitleTextStyle()
                    }
                    .padding()
                }
                .padding(.trailing, isStudentPresented ? 0 : 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(4)
                Spacer()
                VStack(spacing: 20) {
                    NavigationLink(destination: EmptyView()) {
                        HStack {
                            Image(systemName: "star")
                                .frame(alignment: .leading)
                                .padding(.leading, 20)
                            Text("Historik")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.leading, -50)
                        }
                    }
                    .buttonStyle(Resources.CustomButtonStyle.FilledButtonStyle())
                    
                    isStudentPresented ? nil : NavigationLink(destination: StudentListView(selectedClass: className)) {
                        HStack {
                            Image(systemName: "person.3")
                                .frame(alignment: .leading)
                                .padding(.leading, 20)
                            Text("Elever")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.leading, -50)
                        }
                    }
                    .buttonStyle(Resources.CustomButtonStyle.FilledButtonStyle())
                }
                Spacer()
                VStack {
                    PieChart()
                        .data(demoData)
                        .chartStyle(ChartStyle(backgroundColor: .white,
                                               foregroundColor: ColorGradient(Resources.Color.Colors.darkBlue, Resources.Color.Colors.darkBlue)))
                }
                .frame(width: 150, height: 150)
                Spacer()
                VStack(alignment: .leading, spacing: -10) {
                    Text("Statistik")
                        .darkBlueBodyTextStyle()
                        .padding(.leading, 20)
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
                    .background(Resources.Color.Colors.darkBlue)
                    .cornerRadius(2)
                    .padding()
                }
                Spacer()
            }
        }
        .navigationTitle(isStudentPresented ? "Elev" : className)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(className: "ClassName", isStudentPresented: true)
    }
}
