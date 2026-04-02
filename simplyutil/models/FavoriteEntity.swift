//
//  FavoriteEntity.swift
//  simplyutil
//
//  Created by Omri Shapira on 21/03/2024.
//

import Foundation
import SwiftData

@Model
@available(iOS 17, *)
class FavoriteEntity {
    // Use a UUID as the unique identifier, not the city's API id
    @Attribute(.unique) var uniqueId: UUID
    var cityId: Int  // Store the original city ID for reference
    var name: String
    var threeLetterCode: String
    var currency: String
    var country: String
    var isFavorite: Bool
    
    init(cityId: Int, name: String, threeLetterCode: String, currency: String, country: String, isFavorite: Bool) {
        self.uniqueId = UUID()  // Generate a new UUID for each favorite
        self.cityId = cityId
        self.name = name
        self.threeLetterCode = threeLetterCode
        self.currency = currency
        self.country = country
        self.isFavorite = isFavorite
    }
    
    convenience init(item: CityDTO) {
        self.init(
            cityId: item.id,
            name: item.name,
            threeLetterCode: item.threeLetterCode,
            currency: item.currency,
            country: item.country,
            isFavorite: false
        )
    }
}
