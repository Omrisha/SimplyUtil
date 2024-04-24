//
//  DayDTO.swift
//  simplyutil
//
//  Created by Omri Shapira on 23/03/2024.
//

import SwiftUI

struct DayDTO: Codable {
    let maxTemperatureCelsius: Float
    let maxTemperatureFarenheit: Float
    let minTemperatureCelsius: Float
    let minTemperatureFarenheit: Float
    let averageTemperatureCelsius: Int
    let averageTemperatureFarenheit: Int
    
    enum CodingKeys: String, CodingKey {
        case maxTemperatureCelsius = "maxTemperatureCelcius"
        case maxTemperatureFarenheit = "maxTemperatureFarenheit"
        case minTemperatureCelsius = "minTemperatureCelcius"
        case minTemperatureFarenheit = "minTemperatureFarenheit"
        case averageTemperatureCelsius = "averageTemperatureCelcius"
        case averageTemperatureFarenheit = "averageTemperatureFarenheit"
    }
}
