//
//  ForecastRowCell.swift
//  SimplyForecast
//
//  Created by Omri Shapira on 24/10/2019.
//  Copyright © 2019 Omri Shapira. All rights reserved.
//

import SwiftUI

struct ForecastRowCell: View {
    var forecast: ForecastsDTO
    @Binding var tempType: Bool
    @State private var dayOfTheWeek: String = ""
    
    var body: some View {
        HStack {
            Text(forecast.date.getTodayWeekDay())
                .font(.headline)
                .fontWeight(.light)
                .foregroundColor(Color.primary)
                .padding(.trailing, 8)
            Text("\(Int(tempType ? forecast.day.minTemperatureCelsius :forecast.day.minTemperatureFarenheit))°")
            CustomSlider(value: Binding.constant(CGFloat(tempType ? forecast.day.averageTemperatureCelsius : forecast.day.averageTemperatureFarenheit)), maxValue: CGFloat(tempType ? forecast.day.maxTemperatureCelsius : forecast.day.maxTemperatureFarenheit))
                .frame(width: 150, height: 10)
            Text("\(Int(tempType ? forecast.day.maxTemperatureCelsius : forecast.day.maxTemperatureFarenheit))°")
        }
        .padding()
    }
}
