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
    let api: GraphQLAPI = GraphQLAPI()
    
    func fetchLandmarks(cityName: String, country: String) async -> Places? {
        // Using Foursquare Places API (safe, reputable, free tier with 50k calls/month)
        // Get your free API key at: https://foursquare.com/developers/signup
        
        do {
            // Step 1: Get coordinates for the city
            let location: CLLocation? = await getCoordinate(addressString: "\(cityName), \(country)")
            
            guard let location = location else {
                print("Could not get coordinates for \(cityName), \(country)")
                return nil
            }
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            // Step 2: Use Foursquare Places API
            // You can get your own free API key at: https://foursquare.com/developers/signup
            // For now, using a test key (replace with your own)
            // CN3LPT4UOWALCXGIYNKVX5UWLK5G3ISR1FFN0GQXAFLBWNT3
            let apiKey = "K2OZJS5BNP4VBNWKF5LKFUSCE321JMQU5RHLAWQZBHZQ2O12+H0C14NHMVO2MFJE152KN1L1OK2HAUMKHWKYAQC0MK014J2AX" // Replace this with your Foursquare API key
            
            // Check if this is a v2 API key (old format) or v3 OAuth token (new format)
            let isV2Key = !apiKey.starts(with: "fsq3")
            
            if isV2Key {
                // Use Foursquare v2 API (old format, still works)
                return try await fetchLandmarksV2(apiKey: apiKey, latitude: latitude, longitude: longitude, cityName: cityName)
            }
            
            // Use Foursquare v3 API (new format)
            // Search for places near the city
            var components = URLComponents(string: "https://api.foursquare.com/v3/places/search")!
            components.queryItems = [
                URLQueryItem(name: "ll", value: "\(latitude),\(longitude)"),
                URLQueryItem(name: "radius", value: "5000"), // 5km
                URLQueryItem(name: "categories", value: "10000,12000,16000"), // Arts, Culture, Landmarks
                URLQueryItem(name: "limit", value: "20")
            ]
            
            guard let url = components.url else {
                print("Invalid URL for Foursquare")
                return nil
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(apiKey, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.timeoutInterval = 30
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                print("Foursquare API Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode != 200 {
                    if let errorString = String(data: data, encoding: .utf8) {
                        print("Foursquare API Error Response: \(errorString)")
                    }
                    
                    // If API key is not set, return mock data for testing
                    if apiKey.contains("YOUR_API_KEY") {
                        print("⚠️ Using mock landmark data. Get a free Foursquare API key at: https://foursquare.com/developers/signup")
                        return createMockPlaces(cityName: cityName, latitude: latitude, longitude: longitude)
                    }
                    
                    return nil
                }
            }
            
            // Decode Foursquare response
            let foursquareResponse = try JSONDecoder().decode(FoursquareResponse.self, from: data)
            print("Found \(foursquareResponse.results.count) places from Foursquare")
            
            // Convert to your Places format
            let places = convertFoursquareToPlaces(foursquareResponse.results)
            return places
            
        } catch let decodingError as DecodingError {
            print("Error decoding landmark data:")
            switch decodingError {
            case .keyNotFound(let key, let context):
                print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("Type '\(type)' mismatch: \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("Value '\(type)' not found: \(context.debugDescription)")
            case .dataCorrupted(let context):
                print("Data corrupted: \(context.debugDescription)")
            @unknown default:
                print("Unknown decoding error")
            }
        } catch {
            print("Error fetching landmark data:")
            print(error.localizedDescription)
        }
        return nil
    }
    
    // Foursquare v2 API (supports old API keys)
    private func fetchLandmarksV2(apiKey: String, latitude: Double, longitude: Double, cityName: String) async throws -> Places? {
        // Split the key - old v2 keys are CLIENT_ID + CLIENT_SECRET
        let keyParts = apiKey.split(separator: "+")
        let clientId = String(keyParts.first ?? "")
        let clientSecret = keyParts.count > 1 ? String(keyParts[1]) : apiKey
        
        var components = URLComponents(string: "https://api.foursquare.com/v2/venues/explore")!
        components.queryItems = [
            URLQueryItem(name: "ll", value: "\(latitude),\(longitude)"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "v", value: "20240101"), // API version date
            URLQueryItem(name: "radius", value: "5000"),
            URLQueryItem(name: "section", value: "sights"),
            URLQueryItem(name: "limit", value: "20")
        ]
        
        guard let url = components.url else {
            print("Invalid URL for Foursquare v2")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Foursquare v2 API Status Code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode != 200 {
                if let errorString = String(data: data, encoding: .utf8) {
                    print("Foursquare v2 API Error Response: \(errorString)")
                }
                return createMockPlaces(cityName: cityName, latitude: latitude, longitude: longitude)
            }
        }
        
        // Decode v2 response
        let v2Response = try JSONDecoder().decode(FoursquareV2Response.self, from: data)
        print("Found \(v2Response.response.groups.first?.items.count ?? 0) places from Foursquare v2")
        
        guard let items = v2Response.response.groups.first?.items else {
            return createMockPlaces(cityName: cityName, latitude: latitude, longitude: longitude)
        }
        
        // Convert v2 format to your Places format
        return convertFoursquareV2ToPlaces(items)
    }
    
    // Helper to convert Foursquare v2 format to Places
    private func convertFoursquareV2ToPlaces(_ items: [FoursquareV2Item]) -> Places {
        print("Converting \(items.count) Foursquare v2 items to Landmarks...")
        
        let landmarks: [Landmark] = items.compactMap { item in
            let venue = item.venue
            let jsonDict: [String: Any] = [
                "displayName": [
                    "text": venue.name,
                    "languageCode": "en"
                ],
                "formattedAddress": venue.location.formattedAddress?.joined(separator: ", ") ?? venue.location.address ?? "",
                "location": [
                    "latitude": venue.location.lat,
                    "longitude": venue.location.lng
                ],
                "rating": venue.rating ?? 0.0,
                "businessStatus": "OPERATIONAL",
                "photos": [] as [[String: Any]]
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
                let landmark = try JSONDecoder().decode(Landmark.self, from: jsonData)
                print("✅ Converted: \(venue.name) at \(venue.location.lat), \(venue.location.lng)")
                return landmark
            } catch {
                print("❌ Error converting Foursquare v2 place '\(venue.name)': \(error)")
                return nil
            }
        }
        
        print("Successfully converted \(landmarks.count) landmarks")
        return Places(places: landmarks)
    }
    
    // Original v3 conversion function
    private func convertFoursquareToPlaces(_ foursquarePlaces: [FoursquarePlace]) -> Places {
        let landmarks: [Landmark] = foursquarePlaces.compactMap { fsPlace in
            let jsonDict: [String: Any] = [
                "displayName": [
                    "text": fsPlace.name,
                    "languageCode": "en"
                ],
                "formattedAddress": fsPlace.location.formatted_address ?? fsPlace.location.address ?? "",
                "location": [
                    "latitude": fsPlace.geocodes.main.latitude,
                    "longitude": fsPlace.geocodes.main.longitude
                ],
                "rating": fsPlace.rating ?? 0.0,
                "businessStatus": "OPERATIONAL",
                "photos": [] as [[String: Any]]
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
                let landmark = try JSONDecoder().decode(Landmark.self, from: jsonData)
                return landmark
            } catch {
                print("Error converting Foursquare place '\(fsPlace.name)': \(error)")
                return nil
            }
        }
        
        return Places(places: landmarks)
    }
    
    // Fallback: Create mock places for testing when API key is not configured
    private func createMockPlaces(cityName: String, latitude: Double, longitude: Double) -> Places {
        let mockPlaces = [
            ("City Center", "Main downtown area", 4.5),
            ("Historic District", "Old town with historic buildings", 4.3),
            ("Central Park", "Public park and recreation area", 4.2),
            ("Museum Quarter", "Cultural museums and galleries", 4.4),
            ("City Hall", "Municipal government building", 4.0)
        ]
        
        let landmarks: [Landmark] = mockPlaces.compactMap { (name, description, rating) in
            let jsonDict: [String: Any] = [
                "displayName": [
                    "text": name,
                    "languageCode": "en"
                ],
                "formattedAddress": "\(description), \(cityName)",
                "location": [
                    "latitude": latitude + Double.random(in: -0.01...0.01),
                    "longitude": longitude + Double.random(in: -0.01...0.01)
                ],
                "rating": rating,
                "businessStatus": "OPERATIONAL",
                "photos": [] as [[String: Any]]
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
                return try JSONDecoder().decode(Landmark.self, from: jsonData)
            } catch {
                return nil
            }
        }
        
        return Places(places: landmarks)
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
    
    func fetchWeather(cityName: String) async -> [LocationWeatherDTO] {
        do {
            let location: CLLocation? = await getCoordinate(addressString: cityName)
            
            let longitude: Double = location?.coordinate.longitude ?? 0.0
            let latitude: Double = location?.coordinate.latitude ?? 0.0
            
            // Use the new WeatherOperation instead of GraphQLOperation
            let weatherOperation = WeatherOperation.WEATHER(latitude: latitude, longitude: longitude)
            let request = weatherOperation.getURLRequest()
            
            // Fetch weather data from Open-Meteo API
            let (data, _) = try await URLSession.shared.data(for: request)
            let itemData = try JSONDecoder().decode(WeatherResponse.self, from: data)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            let datetimes: [Date?] = itemData.hourly.time.map { time in dateFormatter.date(from: time)}
            var forecasts: [LocationWeatherDTO] = []
            for (i, date) in datetimes.enumerated() {
                let celsius = Float(itemData.hourly.temperature[i])
                let fahrenheit = (celsius * 9/5) + 32
                forecasts.append(LocationWeatherDTO(
                    dayOfTheWeek: date!.getTodayWeekDay(),
                    time: date!,
                    temperature: celsius,
                    fahrenheit: fahrenheit,
                    windSpeed: Float(itemData.hourly.windSpeed[i]),
                    relativeHumidity: itemData.hourly.relativeHumidity[i]
                ))
            }
            
            return forecasts
        } catch {
            print("Error fetching weather data")
            print(error.localizedDescription)
        }
        return []
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
                // Use the new CitiesOperation to fetch cities from REST Countries API
                do {
                    let itemData: [CityDTO] = try await CitiesOperation.fetchCities()
                    print("Successfully fetched \(itemData.count) cities")
                    
                    for eachItem in itemData {
                        let itemToStore = CityEntity(item: eachItem)
                        modelContext.insert(itemToStore)
                    }
                } catch {
                    print("Error fetching cities from REST Countries API:")
                    print(error.localizedDescription)
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .keyNotFound(let key, let context):
                            print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                        case .typeMismatch(let type, let context):
                            print("Type '\(type)' mismatch: \(context.debugDescription)")
                        case .valueNotFound(let type, let context):
                            print("Value '\(type)' not found: \(context.debugDescription)")
                        case .dataCorrupted(let context):
                            print("Data corrupted: \(context.debugDescription)")
                        @unknown default:
                            print("Unknown decoding error")
                        }
                    }
                    throw error
                }
            }
        } catch {
            print("Error updating database")
            print(error.localizedDescription)
        }
    }
}

// MARK: - Foursquare v3 API Models
struct FoursquareResponse: Codable {
    let results: [FoursquarePlace]
}

struct FoursquarePlace: Codable {
    let name: String
    let geocodes: Geocodes
    let location: FoursquareLocation
    let rating: Double?
    
    struct Geocodes: Codable {
        let main: Coordinate
        
        struct Coordinate: Codable {
            let latitude: Double
            let longitude: Double
        }
    }
    
    struct FoursquareLocation: Codable {
        let address: String?
        let formatted_address: String?
    }
}

// MARK: - Foursquare v2 API Models
struct FoursquareV2Response: Codable {
    let response: Response
    
    struct Response: Codable {
        let groups: [Group]
        
        struct Group: Codable {
            let items: [FoursquareV2Item]
        }
    }
}
struct FoursquareV2Item: Codable {
    let venue: Venue
    
    struct Venue: Codable {
        let name: String
        let location: Location
        let rating: Double?
        
        struct Location: Codable {
            let lat: Double
            let lng: Double
            let address: String?
            let formattedAddress: [String]?
        }
    }
}

