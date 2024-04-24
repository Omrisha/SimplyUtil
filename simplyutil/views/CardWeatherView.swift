//
//  CardWeatherView.swift
//  simplyutil
//
//  Created by Omri Shapira on 24/04/2024.
//

import SwiftUI

struct CardWeatherView: View {
    var weather: [LocationWeatherDTO]
    var title: String
    var titleImage: String
    @Binding var tempKind: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(10.0)
                .frame(height: 100)
                .background(Color.clear)
                .opacity(0.1)
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image(systemName: titleImage)
                    Text(title)
                }.padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 0))
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(weather) { today in
                            VStack {
                                if today.time.get(.hour) == Date.now.get(.hour) {
                                    Text("Now")
                                        .font(.subheadline)
                                } else {
                                    Text(today.time, format: .dateTime.hour().minute())
                                        .font(.subheadline)
                                }
                                switch (title) {
                                    case "Wind":
                                        Text("\((String(format: "%.2f", today.windSpeed)))")
                                            .font(.subheadline)
                                    case "Temperature":
                                    Text("\((String(format: "%.2f", self.tempKind ? today.temperature : today.fahrenheit)))°")
                                            .font(.subheadline)
                                    case "Humidity":
                                        Text("\((String(format: "%.2f", today.relativeHumidity)))")
                                            .font(.subheadline)
                                    default:
                                        Text("\((String(format: "%.2f", today.temperature)))")
                                            .font(.subheadline)
                                }
                            }
                        }
                    }
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            }
        }.padding()
    }
}

#Preview {
    CardWeatherView(weather: [LocationWeatherDTO(dayOfTheWeek: "Wed", time: Date.now, temperature: 20, fahrenheit: 60, windSpeed: 39.8, relativeHumidity: 70)], title: "Wind", titleImage: "wind", tempKind: Binding.constant(true))
}
