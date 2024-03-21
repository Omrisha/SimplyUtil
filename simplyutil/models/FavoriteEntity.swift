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
    @Attribute(.unique) var id: Int
    var name: String
    var threeLetterCode: String
    var currency: String
    var country: String
    var isFavorite: Bool
    
    init(id: Int, name: String, threeLetterCode: String, currency: String, country: String, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.threeLetterCode = threeLetterCode
        self.currency = currency
        self.country = country
        self.isFavorite = isFavorite
    }
    
    convenience init(item: CityDTO) {
        self.init(
            id: item.id,
            name: item.name,
            threeLetterCode: item.threeLetterCode,
            currency: item.currency,
            country: item.country,
            isFavorite: false
        )
    }
}
