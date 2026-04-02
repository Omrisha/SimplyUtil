//
//  WebService.swift
//  simplyutil
//
//  Created by Omri Shapira on 20/03/2024.
//

import Foundation
import SwiftData
import CoreLocation

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}

struct GetLandmarkByCityName: Codable {
    var textQuery: String
}

@available(iOS 17, *)
class WebService {
    
    private let apiClient = UnifiedAPIClient.shared
    
    func fetchLandmarks(cityName: String, country: String) async -> Places? {
        do {
            return try await apiClient.fetchLandmarks(cityName: cityName, country: country)
        } catch {
            print("Error fetching landmarks: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchRates(currency: String) async -> RateDTO? {
        do {
            return try await apiClient.fetchRates(currency: currency)
        } catch {
            print("Error fetching rates: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchWeather(cityName: String) async -> [LocationWeatherDTO] {
        do {
            return try await apiClient.fetchWeather(cityName: cityName)
        } catch {
            print("Error fetching weather: \(error.localizedDescription)")
            return []
        }
    }
    
    @MainActor
    func createModelInDatabase(item: CityDTO, modelContext: ModelContext) async {
        do {
            try modelContext.transaction {
                let favorite = FavoriteEntity(
                    cityId: item.id,
                    name: item.name,
                    threeLetterCode: item.threeLetterCode,
                    currency: item.currency,
                    country: item.country,
                    isFavorite: true
                )
                modelContext.insert(favorite)
            }
        } catch {
            print("Error adding favorite")
            print(error.localizedDescription)
        }
    }
}

