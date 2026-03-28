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
    func createModelInDatabase(item: CityEntity, modelContext: ModelContext) async {
        do {
            try modelContext.transaction {
                let favorite = FavoriteEntity(id: item.id, name: item.name, threeLetterCode: item.threeLetterCode, currency: item.currency, country: item.country, isFavorite: true)
                modelContext.insert(favorite)
            }
        } catch {
            print("Error fetching data")
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func updateDataInDatabase(modelContext: ModelContext)  async {
        do {
            var citiesDescriptor = FetchDescriptor<CityEntity>()
            citiesDescriptor.fetchLimit = 1
            
            let persistedCities = try modelContext.fetch(citiesDescriptor)
            
            if persistedCities.isEmpty {
                print("Update database from server")
                do {
                    let itemData: [CityDTO] = try await apiClient.fetchCities()
                    print("Successfully fetched \(itemData.count) cities from server")
                    
                    for eachItem in itemData {
                        let itemToStore = CityEntity(item: eachItem)
                        modelContext.insert(itemToStore)
                    }
                } catch {
                    print("Error fetching cities from server:")
                    print(error.localizedDescription)
                    throw error
                }
            }
        } catch {
            print("Error updating database")
            print(error.localizedDescription)
        }
    }
}

