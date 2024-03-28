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
    @Binding var tempType: Bool
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
            Text("\(Int(tempType ? days.day.minTemperatureCelsius : days.day.minTemperatureFarenheit))°")
            CustomSlider(value: Binding.constant(tempType ? days.day.averageTemperatureCelsius : days.day.averageTemperatureFarenheit), maxValue: tempType ? days.day.maxTemperatureCelsius : days.day.maxTemperatureFarenheit)
                .frame(width: 150, height: 10)
            Text("\(Int(tempType ? days.day.maxTemperatureCelsius : days.day.maxTemperatureFarenheit))°")
        }
        .padding()
        .onAppear{
            if let date = self.days.date.toDate(dateFormatter: DateFormatter(format: "yyyy-MM-dd")) {
                dayOfTheWeek = date.getTodayWeekDay()
            }
        }
    }
}
