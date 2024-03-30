//
//  Landmark.swift
//  simplyutil
//
//  Created by Omri Shapira on 28/03/2024.
//

import Foundation
import SwiftUI
import CoreLocation

struct Places: Hashable, Codable {
    let places: [Landmark]
}

struct Landmark: Hashable, Codable {
    let formattedAddress: String
    let location: Location
    var locationCoordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: location.latitude,
            longitude: location.longitude)
    }
    let rating: Double
    let businessStatus: String
    let displayName: DisplayName
    private let photos: [Photo]
    var images: [String] {
        photos.map { img in
            print("\(displayName.text) -> https://places.googleapis.com/v1/\(img.name)/media?maxHeightPx=400&maxWidthPx=400&key=\(EnvironmentKeys.apiKey)")
            return "https://places.googleapis.com/v1/\(img.name)/media?maxHeightPx=400&maxWidthPx=400&key=\(EnvironmentKeys.apiKey)" }
    }
    
    struct Location: Hashable, Codable {
        let latitude: Double
        let longitude: Double
        
        enum CodingKeys: CodingKey {
            case latitude
            case longitude
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Landmark.Location.CodingKeys> = try decoder.container(keyedBy: Landmark.Location.CodingKeys.self)
            self.latitude = try container.decode(Double.self, forKey: Landmark.Location.CodingKeys.latitude)
            self.longitude = try container.decode(Double.self, forKey: Landmark.Location.CodingKeys.longitude)
        }
    }
    
    struct DisplayName: Hashable, Codable {
        let text: String
        let languageCode: String
        
        enum CodingKeys: CodingKey {
            case text
            case languageCode
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Landmark.DisplayName.CodingKeys> = try decoder.container(keyedBy: Landmark.DisplayName.CodingKeys.self)
            self.text = try container.decode(String.self, forKey: Landmark.DisplayName.CodingKeys.text)
            self.languageCode = try container.decode(String.self, forKey: Landmark.DisplayName.CodingKeys.languageCode)
        }
    }

    struct Photo: Hashable, Codable {
        let name: String
        let widthPx: Int
        let heightPx: Int
        
        enum CodingKeys: CodingKey {
            case name
            case widthPx
            case heightPx
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Landmark.Photo.CodingKeys> = try decoder.container(keyedBy: Landmark.Photo.CodingKeys.self)
            self.name = try container.decode(String.self, forKey: Landmark.Photo.CodingKeys.name)
            self.widthPx = try container.decode(Int.self, forKey: Landmark.Photo.CodingKeys.widthPx)
            self.heightPx = try container.decode(Int.self, forKey: Landmark.Photo.CodingKeys.heightPx)
        }
    }
    
    enum CodingKeys: CodingKey {
        case formattedAddress
        case location
        case rating
        case businessStatus
        case displayName
        case photos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.formattedAddress = try container.decode(String.self, forKey: .formattedAddress)
        self.location = try container.decode(Landmark.Location.self, forKey: .location)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.businessStatus = try container.decode(String.self, forKey: .businessStatus)
        self.displayName = try container.decode(Landmark.DisplayName.self, forKey: .displayName)
        self.photos = try container.decode([Landmark.Photo].self, forKey: .photos)
    }
}
