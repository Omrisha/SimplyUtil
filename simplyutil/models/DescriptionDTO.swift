//
//  DescriptionDTO.swift
//  simplyutil
//
//  Created by Omri Shapira on 20/03/2024.
//

import Foundation

struct DescriptionDTO: Codable {
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case description = "text"
        case icon = "icon"
    }
}
