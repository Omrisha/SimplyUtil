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

struct GetLandmarkByCityName: Codable {
    var textQuery: String
}

@available(iOS 17, *)
class WebService {
    let api: GraphQLAPI = GraphQLAPI()
    
    func fetchLandmarks(cityName: String, country: String) async -> Places? {
        do {
            let url = URL(string: "https://places.googleapis.com/v1/places:searchText")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            var input: GetLandmarkByCityName = GetLandmarkByCityName(textQuery: "Places to visit in \(cityName), \(country)")
            request.httpBody = try JSONEncoder().encode(input)
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("AIzaSyCY8tE6b4IZtYbltP2LUrV0wY982vaz8Pw", forHTTPHeaderField: "X-Goog-Api-Key")
            request.setValue("places.displayName,places.formattedAddress,places.location,places.rating,places.businessStatus,places.photos.name,places.photos.heightPx,places.photos.widthPx", forHTTPHeaderField: "X-Goog-FieldMask")
            
            do {
                let (data, _) = try await URLSession.shared.getData(from: request)
                
                let result = try JSONDecoder().decode(Places.self, from: data)
                return result
            } catch {
                print("Error fetching landmark data from google place")
            }

        } catch {
            print("Invalid data")
        }
        return nil
    }
    
    func fetchRates(currency: String) async -> RateDTO? {
        let url = URL(string: "https://v6.exchangerate-api.com/v6/c04b66e4d1f1f147c60834b3/latest/\(currency)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        do {
            // Make the API call
            let (data, _) = try await URLSession.shared.getData(from: request)
            
            // Attempt to parse into our `Output`
            let result = try JSONDecoder().decode(RateDTO.self, from: data)
            return result
        } catch {
            print("Invalid data")
        }
        
        return nil
    }
    
    func fetchWeather(cityName: String) async -> WeatherDTO? {
        do {
            let itemData: WeatherDTO = try await self.api.performOperation(GraphQLOperation.WEATHER(forCity: cityName))
            
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
            print("Update database from server")
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
