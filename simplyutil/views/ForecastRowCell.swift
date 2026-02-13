//
//  ForecastRowCell.swift
//  SimplyForecast
//
//  Created by Omri Shapira on 24/10/2019.
//  Copyright © 2019 Omri Shapira. All rights reserved.
//

import SwiftUI

struct ForecastRowCell: View {
    let forecasts: [ForecastsDTO]
    @Binding var tempType: Bool
    
    private var limitedForecasts: [ForecastsDTO] {
        Array(forecasts.prefix(10))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Text("10-Day Forecast")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            
            if limitedForecasts.isEmpty {
                Text("No forecast data available")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(limitedForecasts) { forecast in
                            VStack(spacing: 8) {
                                Text(forecast.date.getTodayWeekDay())
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                let temp = tempType ? forecast.averageTemperatureCelsius : forecast.averageTemperatureFarenheit
                                let unit = tempType ? "°C" : "°F"
                                Text("\(Int(temp))\(unit)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            .frame(minWidth: 60)
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        }
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

