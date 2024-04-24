//
//  LocationWeatherDTO.swift
//  simplyutil
//
//  Created by Omri Shapira on 24/04/2024.
//

import Foundation

struct LocationWeatherDTO: Identifiable, Codable {
    let id: UUID = UUID()
    let dayOfTheWeek: String
    let time: Date
    let temperature: Float
    let fahrenheit: Float
    let windSpeed: Float
    let relativeHumidity: Int
    
    enum CodingKeys: String, CodingKey {
        case dayOfTheWeek = "dayOfTheWeek"
        case time = "time"
        case temperature = "temperature"
        case fahrenheit = "fahrenheit"
        case windSpeed = "windSpeed"
        case relativeHumidity = "relativeHumidity"
    }
}
