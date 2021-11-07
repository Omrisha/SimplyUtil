//
//  CityCard.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI

struct CityCard: View {
    var cityData: CityData
    
    var body: some View {
        VStack {
            Text("\(cityData.cityName)")
                .padding([.top], 10)
            Spacer()
            Image(systemName: cityData.forecastIcon)
                .resizable()
                .frame(width: 45, height: 45)
            Spacer()
            HStack(alignment: .bottom) {
                Text(cityData.rate)
                    .padding([.leading, .bottom], 10)
                Spacer()
                Text(String(format: "%.2f °", cityData.degrees))
                    .padding([.trailing, .bottom], 10)
            }
        }.frame(width: 150, height: 150)
        .background(Color.blue)
        .cornerRadius(20)
            .padding()
            .shadow(radius: 10.0, x: 20, y: 10)
    }
}

struct CityCard_Previews: PreviewProvider {
    static var previews: some View {
        CityCard(cityData: testData[0])
            .previewLayout(.sizeThatFits)
    }
}
