//
//  WebService.swift
//  simplyutil
//
//  Created by Omri Shapira on 20/03/2024.
//

import Foundation
import SwiftData

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}

@available(iOS 17, *)
class WebService {
    let api: GraphQLAPI = GraphQLAPI()
    
    func fetchWeather(cityName: String) async -> WeatherDTO? {
        do {
            let itemData: WeatherDTO = try await self.api.performOperation(GraphQLOperation.WEATHER)
            
            return itemData
        } catch {
            print("Error fetching data")
            print(error.localizedDescription)
        }
        return nil
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
            let itemData: [CityDTO] = try await self.api.performOperation(GraphQLOperation.LIST_CITIES)
            
            for eachItem in itemData {
                let itemToStore = CityEntity(item: eachItem)
                modelContext.insert(itemToStore)
            }
        } catch {
            print("Error fetching data")
            print(error.localizedDescription)
        }
    }
}
