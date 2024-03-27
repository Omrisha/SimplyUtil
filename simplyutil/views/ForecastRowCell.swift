//
//  ForecastRowCell.swift
//  SimplyForecast
//
//  Created by Omri Shapira on 24/10/2019.
//  Copyright © 2019 Omri Shapira. All rights reserved.
//

import SwiftUI

struct ForecastRowCell: View {
    var days: ForecastsDTO
    @State private var currentValue: CGFloat = 0
    @State private var dayOfTheWeek: String = ""
    
    var body: some View {
        HStack {
            Text(dayOfTheWeek)
                .font(.headline)
                .fontWeight(.light)
                .foregroundColor(Color.primary)
                .padding(.trailing, 8)
            AsyncImage(url: URL(string: days.day.condition.icon)){  image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 25, height: 25)
                .padding(.trailing, 8)
            Text("\(Int(days.day.minTemperatureCelsius))°")
            CustomSlider(value: $currentValue, maxValue: days.day.maxTemperatureCelsius)
                .frame(width: 150, height: 10)
            Text("\(Int(days.day.maxTemperatureCelsius))°")
        }
        .padding()
        .onAppear{
            if let date = self.days.date.toDate(dateFormatter: DateFormatter(format: "yyyy-MM-dd")) {
                dayOfTheWeek = date.getTodayWeekDay()
            }
            
            currentValue = self.days.day.averageTemperatureCelsius
        }
    }
}

#Preview {
    do {
        let favorite = ForecastsDTO(date: "2024-03-23", day: DayDTO(maxTemperatureCelsius: 20, maxTemperatureFarenheit: 60, minTemperatureCelsius: 10, minTemperatureFarenheit: 40, averageTemperatureCelsius: 15, averageTemperatureFarenheit: 50, condition: ConditionDTO(icon: "https://cdn.weatherapi.com/weather/64x64/day/116.png", text: "Partly Cloudly")))
        return ForecastRowCell(days: favorite)
    } catch {
        fatalError("Failed to create model container")
    }
}
