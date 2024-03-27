//
//  DescriptionDTO.swift
//  simplyutil
//
//  Created by Omri Shapira on 20/03/2024.
//

import SwiftUI

struct ConditionDTO: Codable {
    let icon: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case icon = "icon"
        case text = "text"
    }
}
