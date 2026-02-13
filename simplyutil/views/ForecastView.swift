//
//  ForecastListView.swift
//  simplyutil
//
//  Created by Omri Shapira on 28/03/2024.
//

import SwiftUI

struct ForecastView: View {
    let cityName: String
    @Binding var tempKind: Bool
    
    @State private var forecasts: [ForecastsDTO] = []
    @State private var currentWeather: [LocationWeatherDTO] = []
    @State private var isLoading = false
    @State private var error: Error?
    
    private var sortedForecasts: [ForecastsDTO] {
        forecasts.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        Group {
            if isLoading && currentWeather.isEmpty {
                ProgressView("Loading weather data...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = error {
                ContentUnavailableView {
                    Label("Unable to Load Weather", systemImage: "cloud.slash")
                } description: {
                    Text(error.localizedDescription)
                } actions: {
                    Button("Try Again") {
                        Task {
                            await loadForecast(for: cityName)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else if currentWeather.isEmpty {
                ContentUnavailableView(
                    "No Weather Data",
                    systemImage: "cloud.slash",
                    description: Text("Weather information is not available for \(cityName)")
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        CardWeatherView(
                            weather: currentWeather,
                            title: "Temperature",
                            titleImage: "thermometer.sun",
                            tempKind: $tempKind
                        )
                        
                        CardWeatherView(
                            weather: currentWeather,
                            title: "Wind",
                            titleImage: "wind",
                            tempKind: $tempKind
                        )
                        
                        CardWeatherView(
                            weather: currentWeather,
                            title: "Humidity",
                            titleImage: "humidity",
                            tempKind: $tempKind
                        )
                        
                        ForecastRowCell(
                            forecasts: sortedForecasts,
                            tempType: $tempKind
                        )
                    }
                    .padding()
                }
                .refreshable {
                    await loadForecast(for: cityName)
                }
            }
        }
        .task {
            await loadForecast(for: cityName)
        }
    }
    
    // MARK: - Private Methods
    
    private func loadForecast(for cityName: String) async {
        isLoading = true
        error = nil
        
        defer { isLoading = false }
        
        do {
            let now = Date.now
            let weatherForecasts = await WebService().fetchWeather(cityName: cityName)
            
            // Filter current day weather
            self.currentWeather = weatherForecasts.filter { weather in
                Calendar.current.isDate(weather.time, inSameDayAs: now) &&
                weather.time.get(.hour) >= now.get(.hour)
            }
            
            // Process future forecasts
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let futureWeather = weatherForecasts.filter { weather in
                weather.time >= now
            }
            
            let groupedByDate = Dictionary(grouping: futureWeather) { weather in
                formatter.string(from: weather.time)
            }
            
            self.forecasts = groupedByDate.compactMap { dateString, weatherData in
                guard let date = formatter.date(from: dateString) else { return nil }
                
                let temperatures = weatherData.map { Double($0.temperature) }
                let fahrenheits = weatherData.map { Double($0.fahrenheit) }
                
                let avgCelsius = temperatures.reduce(0.0, +) / Double(temperatures.count)
                let avgFahrenheit = fahrenheits.reduce(0.0, +) / Double(fahrenheits.count)
                
                return ForecastsDTO(
                    date: date,
                    averageTemperatureCelsius: Float(avgCelsius),
                    averageTemperatureFarenheit: Float(avgFahrenheit)
                )
            }
        } catch {
            self.error = error
        }
    }
}

#Preview {
    ForecastView(
        cityName: "Tel Aviv",
        tempKind: .constant(true)
    )
}
