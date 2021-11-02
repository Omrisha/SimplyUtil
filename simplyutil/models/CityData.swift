//
//  CityData.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI

struct CityData : Identifiable {
    let id = UUID()
    let cityName: String
    let country: String
    let countryCode: String
    let forecastIcon: String
    let rate: Double
    let degrees: Double
    let forecast: [ForecastData]
}

#if DEBUG
let testData: [CityData] = [
    CityData(cityName: "Rishon Lezion", country: "Israel", countryCode: "IL", forecastIcon: "sun.min", rate: 4.5, degrees: 29, forecast:
                [ForecastData(date: "11.6.2019", degrees: "30",symbol: "Clear"),
                 ForecastData(date: "12.6.2019", degrees: "28", symbol: "Clear"),
                 ForecastData(date: "13.6.2019", degrees: "27", symbol: "Clear"),
                 ForecastData(date: "14.6.2019", degrees: "32", symbol: "Clear")]),
    CityData(cityName: "London", country: "United Kingdom", countryCode: "UK", forecastIcon: "sun.haze", rate: 4.5, degrees: 29, forecast:
                [ForecastData(date: "11.6.2019", degrees: "30",symbol: "Clear"),
                 ForecastData(date: "12.6.2019", degrees: "28", symbol: "Clear"),
                 ForecastData(date: "13.6.2019", degrees: "27", symbol: "Clear"),
                 ForecastData(date: "14.6.2019", degrees: "32", symbol: "Clear")]),
    CityData(cityName: "New York", country: "United States", countryCode: "USA", forecastIcon: "moon", rate: 4.5, degrees: 29, forecast:
                [ForecastData(date: "11.6.2019", degrees: "30",symbol: "Clear"),
                 ForecastData(date: "12.6.2019", degrees: "28", symbol: "Clear"),
                 ForecastData(date: "13.6.2019", degrees: "27", symbol: "Clear"),
                 ForecastData(date: "14.6.2019", degrees: "32", symbol: "Clear")]),
    CityData(cityName: "Tokyo", country: "Japan", countryCode: "JP", forecastIcon: "sunset", rate: 4.5, degrees: 29, forecast:
                [ForecastData(date: "11.6.2019", degrees: "30",symbol: "Clear"),
                 ForecastData(date: "12.6.2019", degrees: "28", symbol: "Clear"),
                 ForecastData(date: "13.6.2019", degrees: "27", symbol: "Clear"),
                 ForecastData(date: "14.6.2019", degrees: "32", symbol: "Clear")]),
    CityData(cityName: "Sydney", country: "Australia", countryCode: "AUS", forecastIcon: "sunrise", rate: 4.5, degrees: 29, forecast:
                [ForecastData(date: "11.6.2019", degrees: "30",symbol: "Clear"),
                 ForecastData(date: "12.6.2019", degrees: "28", symbol: "Clear"),
                 ForecastData(date: "13.6.2019", degrees: "27", symbol: "Clear"),
                 ForecastData(date: "14.6.2019", degrees: "32", symbol: "Clear")])
]
#endif
