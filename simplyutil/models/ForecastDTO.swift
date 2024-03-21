//
//  ForecastData.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI

struct ForecastDTO: Codable {
    let forecasts: [ForecastsDTO]
    
    enum CodingKeys: String, CodingKey {
        case forecasts = "forecasts"
    }
}

struct ForecastsDTO: Codable {
    let date: String
    let day: DayDTO
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case day = "day"
    }
}

struct DayDTO: Codable {
    let maxTemperatureCelsius: Double
    let maxTemperatureFarenheit: Double
    let minTemperatureCelsius: Double
    let minTemperatureFarenheit: Double
    let averageTemperatureCelsius: Double
    let averageTemperatureFarenheit: Double
    let condition: ConditionDTO
    
    enum CodingKeys: String, CodingKey {
        case maxTemperatureCelsius = "maxTemperatureCelsius"
        case maxTemperatureFarenheit = "maxTemperatureFarenheit"
        case minTemperatureCelsius = "minTemperatureCelsius"
        case minTemperatureFarenheit = "minTemperatureFarenheit"
        case averageTemperatureCelsius = "averageTemperatureCelsius"
        case averageTemperatureFarenheit = "averageTemperatureFarenheit"
        case condition = "condition"
    }
}

struct CurrentDTO: Codable{
    let temperatureCelcius: Double
    let temperatureFarenheit: Double
    let condition: ConditionDTO
    
    enum CodingKeys: String, CodingKey {
        case temperatureCelcius = "temperatureCelcius"
        case temperatureFarenheit = "temperatureFarenheit"
        case condition = "condition"
    }
}

struct ConditionDTO: Codable {
    let icon: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case icon = "icon"
        case text = "text"
    }
}
