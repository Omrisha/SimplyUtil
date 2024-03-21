//
//  ForecastData.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI

struct ForecastDTO: Codable {
    let date: String
    let temperatureCelsius: Double
    let temperatureFarenheit: Double
    let description: DescriptionDTO
    
    enum CodingKeys: String, CodingKey {
        case temperatureCelsius = "temp_c"
        case temperatureFarenheit = "temp_f"
        case weatherDescription = "weather"
        case description = "condition"
        case date = "last_updated"
    }
}

struct CurrentDTO: Codable{
    
}
