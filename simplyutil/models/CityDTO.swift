//
//  CityDTO.swift
//  simplyutil
//
//  Created by Omri Shapira on 20/03/2024.
//

import Foundation

struct CityDTO: Identifiable, Codable {
    var id: Int
    let name: String
    let threeLetterCode: String
    let currency: String
    let country: String
}
