//
//  CityEntity.swift
//  simplyutil
//
//  Created by Omri Shapira on 20/03/2024.
//

import Foundation
import SwiftData

@Model
@available(iOS 17, *)
class CityEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var threeLetterCode: String
    var currency: String
    var country: String
    
    init(id: Int, name: String, threeLetterCode: String, currency: String, country: String) {
        self.id = id
        self.name = name
        self.threeLetterCode = threeLetterCode
        self.currency = currency
        self.country = country
    }
    
    convenience init(item: CityDTO) {
        self.init(
            id: item.id,
            name: item.name,
            threeLetterCode: item.threeLetterCode,
            currency: item.currency,
            country: item.country
        )
    }
}
