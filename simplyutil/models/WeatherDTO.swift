//
//  Weather.swift
//  simplyutil
//
//  Created by Omri Shapira on 20/03/2024.
//

import Foundation

struct WeatherDTO: Codable {
    let current: CurrentDTO
    let forecast: ForecastDTO
    
    enum CodingKeys: String, CodingKey {
        case current = "current"
        case forecast = "forecast"
    }    
}

struct WeatherByLocationDTO: Codable {
    let hourly: Hourly

    struct Hourly: Codable {
        let time: [String]
        let temperature: [Float]
        let windSpeed: [Float]
        let relativeHumidity: [Int]
        
        enum CodingKeys: String, CodingKey {
            case time = "time"
            case temperature = "temperature"
            case windSpeed = "windSpeed"
            case relativeHumidity = "relativeHumidity"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case hourly = "hourly"
    }
}
