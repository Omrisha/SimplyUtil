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
