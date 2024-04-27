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
        GeometryReader { geometry in
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.fixed(geometry.size.width))], content: {
                    CardWeatherView(weather: currentWeather, title: "Temperature", titleImage: "thermometer.sun", tempKind: $tempKind)
                    CardWeatherView(weather: currentWeather, title: "Wind", titleImage: "wind", tempKind: $tempKind)
                    CardWeatherView(weather: currentWeather, title: "Humidity", titleImage: "humidity", tempKind: $tempKind)
                    ForecastRowCell(
                        forecasts: forecasts.sorted { $0.date.get(.day) < $1.date.get(.day) },
                        tempType: $tempKind)
                })
            }.frame(width: geometry.size.width, height: geometry.size.height)
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
            let avgCelsius = celsius.reduce(CGFloat.zero) { $0 + CGFloat($1) } / CGFloat(celsius.count)
            let avgFarenheit = farenheit.reduce(CGFloat.zero) { $0 + CGFloat($1) } / CGFloat(farenheit.count)
            return ForecastsDTO(date: formatter.date(from: forecast.key)!, averageTemperatureCelsius: Float(avgCelsius), averageTemperatureFarenheit: Float(avgFarenheit))
        }
    }
}

#Preview {
    ForecastView(cityName: "Tel Aviv", forecasts: forecasts, currentWeather: [LocationWeatherDTO(dayOfTheWeek: "Wed", time: Date.now, temperature: 20, fahrenheit: 60, windSpeed: 39.8, relativeHumidity: 70)], tempKind: Binding.constant(true))
}

#if DEBUG
let forecasts: [ForecastsDTO] = [
    ForecastsDTO(date: Date.now, averageTemperatureCelsius: 22, averageTemperatureFarenheit: 56),
    ForecastsDTO(date: Date.now, averageTemperatureCelsius: 22, averageTemperatureFarenheit: 56),
    ForecastsDTO(date: Date.now, averageTemperatureCelsius: 22, averageTemperatureFarenheit: 56),
    ForecastsDTO(date: Date.now, averageTemperatureCelsius: 22, averageTemperatureFarenheit: 56)
]
#endif
