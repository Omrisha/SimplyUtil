//
//  RateDTO.swift
//  simplyutil
//
//  Created by Omri Shapira on 27/03/2024.
//

import SwiftUI

struct RateDTO: Identifiable, Codable {
    var id = UUID()
    let rates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case rates = "conversion_rates"
    }
}
