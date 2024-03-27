//
//  ForecastsDTO.swift
//  simplyutil
//
//  Created by Omri Shapira on 23/03/2024.
//

import SwiftUI

struct ForecastsDTO: Identifiable, Codable {
    var id = UUID()
    let date: String
    let day: DayDTO
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case day = "day"
    }
}
