//
//  CardWeatherView.swift
//  simplyutil
//
//  Created by Omri Shapira on 24/04/2024.
//

import SwiftUI

struct CardWeatherView: View {
    let weather: [LocationWeatherDTO]
    let title: String
    let titleImage: String
    @Binding var tempKind: Bool
    
    private var displayValue: (LocationWeatherDTO) -> String {
        { weather in
            switch title {
            case "Wind":
                return String(format: "%.1f km/h", weather.windSpeed)
            case "Temperature":
                let temp = tempKind ? weather.temperature : weather.fahrenheit
                let unit = tempKind ? "°C" : "°F"
                return "\(Int(temp))\(unit)"
            case "Humidity":
                return "\(weather.relativeHumidity)%"
            default:
                return ""
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: titleImage)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            
            if weather.isEmpty {
                Text("No data available")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(weather) { item in
                            VStack(spacing: 8) {
                                Text(timeLabel(for: item.time))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(displayValue(item))
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
    
    // MARK: - Private Methods
    
    private func timeLabel(for date: Date) -> String {
        if Calendar.current.isDate(date, equalTo: Date.now, toGranularity: .hour) {
            return "Now"
        }
        return date.formatted(.dateTime.hour().minute())
    }
}

#Preview {
    CardWeatherView(weather: [LocationWeatherDTO(dayOfTheWeek: "Wed", time: Date.now, temperature: 20, fahrenheit: 60, windSpeed: 39.8, relativeHumidity: 70)], title: "Wind", titleImage: "wind", tempKind: Binding.constant(true))
}
