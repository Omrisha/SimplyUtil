//
//  CityDetailView.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI

struct CityDetailView: View {
    var city: CityData
    @State var valueToConvert: String = ""
    @State var convertedValue: String = ""
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            VStack(alignment: .leading) {
                Text("\(city.cityName), \(city.countryCode)")
                    .font(.largeTitle)
                Text("\(city.country)")
                    .font(.title)
            }
            Spacer()
            VStack {
                HStack(alignment: .center) {
                    CustomTextField(imageName: "chevron.backward.circle", placeholder: "From", text: self.valueToConvert)
                    CustomTextField(imageName: "chevron.right.circle", placeholder: "To", text: self.convertedValue)
                }.padding([.leading, .trailing], 10)
                Text("Current conversion rate: \(String(format: "%.2f", city.rate))")
                    .font(.title2)
                    .padding([.top], 20)
            }
            Spacer()
            List {
                ForEach(city.forecast) { item in
                    ForecastRowCell(day: item)
                }
            }
        }
    }
}

struct CityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CityDetailView(city: testData[0])
            
            CityDetailView(city: testData[0])
                .preferredColorScheme(.dark)
        }
    }
}
