//
//  ForecastListView.swift
//  simplyutil
//
//  Created by Omri Shapira on 28/03/2024.
//

import SwiftUI

struct ForecastView: View {
    var cityName: String
    @State var forecasts: [ForecastsDTO] = []
    @State var currentWeather: [LocationWeatherDTO] = []
    @Binding var tempKind: Bool
    
    var body: some View {
        VStack {
            CardWeatherView(weather: currentWeather, title: "Temperature", titleImage: "thermometer.sun", tempKind: $tempKind)
            CardWeatherView(weather: currentWeather, title: "Wind", titleImage: "wind", tempKind: $tempKind)
            CardWeatherView(weather: currentWeather, title: "Humidity", titleImage: "humidity", tempKind: $tempKind)
            
            ForecastsListView(forecasts: forecasts, tempKind: $tempKind)
                .cornerRadius(10)
                .padding()
        }
        .onAppear {
            Task.init {
                await loadForecast(for: cityName)
            }
        }
    }
    
    func loadForecast(for cityName: String) async {
        let now = Date.now
        let weatherForecasts = await WebService().fetchWeather(cityName: cityName)
        self.currentWeather = weatherForecasts.filter { $0.time.get(.day) == now.get(.day) && $0.time.get(.month) == now.get(.month) && $0.time.get(.hour) >= now.get(.hour)}
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let temp = weatherForecasts.filter { $0.time.get(.day) > now.get(.day) && $0.time.get(.month) >= now.get(.month)}
        let futureForecasts = temp
            .reduce([String: [LocationWeatherDTO]]()) { (dict, item) -> [String: [LocationWeatherDTO]] in
                var dict = dict
                let key = formatter.string(from: item.time)
                dict[key, default: []].append(item)
                return dict
            }
        
        self.forecasts = futureForecasts.map { forecast in
            let celsius = forecast.value.map{$0.temperature}
            let farenheit = forecast.value.map{$0.fahrenheit}
            let avgCelsius = Int(celsius.sum()) / celsius.count
            let avgFarenheit = Int(farenheit.sum()) / farenheit.count
            return ForecastsDTO(date: formatter.date(from: forecast.key)!, day: DayDTO(maxTemperatureCelsius: celsius.max()!, maxTemperatureFarenheit: farenheit.max()!, minTemperatureCelsius: celsius.min()!, minTemperatureFarenheit: farenheit.min()!, averageTemperatureCelsius: avgCelsius, averageTemperatureFarenheit: avgFarenheit))
        }
    }
}

#Preview {
    ForecastView(cityName: "Tel Aviv", currentWeather: [LocationWeatherDTO(dayOfTheWeek: "Wed", time: Date.now, temperature: 20, fahrenheit: 60, windSpeed: 39.8, relativeHumidity: 70)], tempKind: Binding.constant(true))
}
