//
//  ForecastRowCell.swift
//  SimplyForecast
//
//  Created by Omri Shapira on 24/10/2019.
//  Copyright © 2019 Omri Shapira. All rights reserved.
//

import SwiftUI

struct ForecastRowCell: View {
    var forecasts: [ForecastsDTO]
    @Binding var tempType: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(10.0)
                .frame(height: 100)
                .background(Color.clear)
                .opacity(0.1)
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image(systemName: "calendar")
                        .fontWeight(.light)
                    Text("10-DAY Forecast")
                        .fontWeight(.light)
                }.padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 0))
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(forecasts) { forecast in
                            VStack {
                                Text(forecast.date.getTodayWeekDay())
                                    .font(.title2)
                                Text("\(Int(self.tempType ? forecast.averageTemperatureCelsius :forecast.averageTemperatureFarenheit))°")
                            }
                        }
                    }
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            }
        }.padding()
    }
}

#Preview {
    ForecastRowCell(forecasts: [
        ForecastsDTO(date: Date.now, averageTemperatureCelsius: 22, averageTemperatureFarenheit: 56),
        ForecastsDTO(date: Date.now, averageTemperatureCelsius: 22, averageTemperatureFarenheit: 56),
        ForecastsDTO(date: Date.now, averageTemperatureCelsius: 22, averageTemperatureFarenheit: 56),
        ForecastsDTO(date: Date.now, averageTemperatureCelsius: 22, averageTemperatureFarenheit: 56)
    ], tempType: Binding.constant(true))
}

