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
