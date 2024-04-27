//
//  ForecastsDTO.swift
//  simplyutil
//
//  Created by Omri Shapira on 23/03/2024.
//

import SwiftUI

struct ForecastsDTO: Identifiable, Codable {
    var id = UUID()
    let date: Date
    let averageTemperatureCelsius: Float
    let averageTemperatureFarenheit: Float
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case averageTemperatureCelsius = "averageTemperatureCelcius"
        case averageTemperatureFarenheit = "averageTemperatureFarenheit"
    }
}
