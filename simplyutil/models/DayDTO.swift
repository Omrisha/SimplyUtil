//
//  DayDTO.swift
//  simplyutil
//
//  Created by Omri Shapira on 23/03/2024.
//

import SwiftUI

struct DayDTO: Codable {
    let maxTemperatureCelsius: Double
    let maxTemperatureFarenheit: Double
    let minTemperatureCelsius: Double
    let minTemperatureFarenheit: Double
    let averageTemperatureCelsius: Double
    let averageTemperatureFarenheit: Double
    let condition: ConditionDTO
    
    enum CodingKeys: String, CodingKey {
        case maxTemperatureCelsius = "maxTemperatureCelcius"
        case maxTemperatureFarenheit = "maxTemperatureFarenheit"
        case minTemperatureCelsius = "minTemperatureCelcius"
        case minTemperatureFarenheit = "minTemperatureFarenheit"
        case averageTemperatureCelsius = "averageTemperatureCelcius"
        case averageTemperatureFarenheit = "averageTemperatureFarenheit"
        case condition = "condition"
    }
}
