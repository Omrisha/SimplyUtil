//
//  CurrentDTO.swift
//  simplyutil
//
//  Created by Omri Shapira on 23/03/2024.
//

import SwiftUI

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
