//
//  UnifiedAPIClient.swift
//  simplyutil
//
//  Created by Assistant on 13/02/2026.
//

import Foundation

/// Unified API client that communicates with your backend server
class UnifiedAPIClient {
    
    // Replace with your deployed server URL
    // For local testing: "http://localhost:8080/api/v1"
    // For production: "https://app-quiet-rain-433.fly.dev/api/v1"
    private let baseURL = "https://app-quiet-rain-433.fly.dev/api/v1"
    
    static let shared = UnifiedAPIClient()
    
    private init() {}
    
    // MARK: - Cities
    
    /// Fetches list of all cities/countries with currencies
    func fetchCities() async throws -> [CityDTO] {
        let endpoint = "\(baseURL)/cities"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let citiesResponse = try decoder.decode(ServerCitiesResponse.self, from: data)
        return citiesResponse.cities
    }
    
    /// Fetches cities with pagination
    func fetchCities(page: Int, pageSize: Int, searchQuery: String = "") async throws -> ServerCitiesResponse {
        var components = URLComponents(string: "\(baseURL)/cities")!
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "pageSize", value: String(pageSize))
        ]
        
        if !searchQuery.isEmpty {
            components.queryItems?.append(URLQueryItem(name: "search", value: searchQuery))
        }
        
        guard let url = components.url else {
            print("❌ Bad URL: \(baseURL)/cities")
            throw URLError(.badURL)
        }
        
        print("🏙️ Fetching cities from: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Invalid HTTP response")
            throw URLError(.badServerResponse)
        }
        
        print("🏙️ HTTP Status: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            if let errorString = String(data: data, encoding: .utf8) {
                print("❌ Server error response: \(errorString)")
            }
            throw URLError(.badServerResponse)
        }
        
        // Debug: Print raw response
        if let jsonString = String(data: data, encoding: .utf8) {
            print("🏙️ Response preview: \(jsonString.prefix(200))...")
        }
        
        let decoder = JSONDecoder()
        do {
            let citiesResponse = try decoder.decode(ServerCitiesResponse.self, from: data)
            print("✅ Successfully decoded \(citiesResponse.cities.count) cities")
            return citiesResponse
        } catch {
            print("❌ Decoding error: \(error)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("   Missing key: \(key.stringValue) at \(context.codingPath)")
                case .typeMismatch(let type, let context):
                    print("   Type mismatch: expected \(type) at \(context.codingPath)")
                case .valueNotFound(let type, let context):
                    print("   Value not found: \(type) at \(context.codingPath)")
                case .dataCorrupted(let context):
                    print("   Data corrupted at: \(context.codingPath)")
                @unknown default:
                    print("   Unknown decoding error")
                }
            }
            throw error
        }
    }
    
    // MARK: - Landmarks
    
    /// Fetches landmarks for a city
    func fetchLandmarks(cityName: String, country: String) async throws -> Places {
        var components = URLComponents(string: "\(baseURL)/landmarks")!
        components.queryItems = [
            URLQueryItem(name: "city", value: cityName),
            URLQueryItem(name: "country", value: country)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let landmarksResponse = try decoder.decode(ServerLandmarksResponse.self, from: data)
        
        // Convert server landmarks to app's Landmark format
        return Places(places: landmarksResponse.landmarks.compactMap { serverLandmark in
            convertServerLandmarkToLandmark(serverLandmark)
        })
    }
    
    // MARK: - Weather
    
    /// Fetches weather forecast for a city
    func fetchWeather(cityName: String) async throws -> [LocationWeatherDTO] {
        var components = URLComponents(string: "\(baseURL)/weather")!
        components.queryItems = [
            URLQueryItem(name: "city", value: cityName)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let weatherResponse = try decoder.decode(ServerWeatherResponse.self, from: data)
        
        // Convert to LocationWeatherDTO
        return convertServerWeatherToLocationWeather(weatherResponse.weather)
    }
    
    // MARK: - Exchange Rates
    
    /// Fetches exchange rates for a currency
    func fetchRates(currency: String) async throws -> RateDTO {
        let endpoint = "\(baseURL)/rates/\(currency)"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        print("📊 Fetching rates for \(currency) from: \(endpoint)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("📊 Rates API Status Code: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            if let errorString = String(data: data, encoding: .utf8) {
                print("📊 Rates API Error: \(errorString)")
            }
            throw URLError(.badServerResponse)
        }
        
        // Debug: Print raw response
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📊 Rates Response: \(jsonString.prefix(200))...")
        }
        
        let decoder = JSONDecoder()
        let ratesResponse = try decoder.decode(ServerRatesResponse.self, from: data)
        
        print("📊 Successfully decoded \(ratesResponse.rates.count) exchange rates")
        
        // Convert to RateDTO format (only needs rates dictionary)
        return RateDTO(rates: ratesResponse.rates)
    }
    
    // MARK: - Helper Conversion Functions
    
    private func convertServerLandmarkToLandmark(_ serverLandmark: ServerLandmark) -> Landmark? {
        // Create a photo object if imageUrl is available
        var photos: [[String: Any]] = []
        if let imageUrl = serverLandmark.imageUrl, !imageUrl.isEmpty {
            // For direct URLs, store them in the photo name field
            // The Landmark.images property will detect and handle them
            photos.append([
                "name": imageUrl,
                "widthPx": 400,
                "heightPx": 400
            ])
        }
        
        let jsonDict: [String: Any] = [
            "displayName": [
                "text": serverLandmark.name,
                "languageCode": "en"
            ],
            "formattedAddress": serverLandmark.address,
            "location": [
                "latitude": serverLandmark.latitude,
                "longitude": serverLandmark.longitude
            ],
            "rating": serverLandmark.rating,
            "businessStatus": "OPERATIONAL",
            "photos": photos
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
            return try JSONDecoder().decode(Landmark.self, from: jsonData)
        } catch {
            print("Error converting server landmark: \(error)")
            return nil
        }
    }
    
    private func convertServerWeatherToLocationWeather(_ serverWeather: ServerWeatherData) -> [LocationWeatherDTO] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return serverWeather.hourly.compactMap { hourly in
            guard let date = dateFormatter.date(from: hourly.time) else { return nil }
            
            let celsius = Float(hourly.temperature)
            let fahrenheit = (celsius * 9/5) + 32
            
            return LocationWeatherDTO(
                dayOfTheWeek: date.getTodayWeekDay(),
                time: date,
                temperature: celsius,
                fahrenheit: fahrenheit,
                windSpeed: Float(hourly.windSpeed),
                relativeHumidity: hourly.relativeHumidity
            )
        }
    }
}

// MARK: - Server Response Models

struct ServerCitiesResponse: Codable {
    let cities: [CityDTO]
    let count: Int
}

struct ServerLandmarksResponse: Codable {
    let landmarks: [ServerLandmark]
    let count: Int
}

struct ServerLandmark: Codable {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let rating: Double
    let imageUrl: String?
}

struct ServerWeatherResponse: Codable {
    let weather: ServerWeatherData
}

struct ServerWeatherData: Codable {
    let latitude: Double
    let longitude: Double
    let hourly: [ServerHourlyForecast]
}

struct ServerHourlyForecast: Codable {
    let time: String
    let temperature: Double
    let windSpeed: Double
    let relativeHumidity: Int
}

struct ServerRatesResponse: Codable {
    let baseCurrency: String
    let rates: [String: Double]
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case baseCurrency
        case rates
        case timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseCurrency = try container.decode(String.self, forKey: .baseCurrency)
        self.rates = try container.decode([String: Double].self, forKey: .rates)
        
        // Handle timestamp - it might be a string or unix timestamp
        if let timestampString = try? container.decode(String.self, forKey: .timestamp) {
            let formatter = ISO8601DateFormatter()
            self.timestamp = formatter.date(from: timestampString) ?? Date()
        } else if let timestampDouble = try? container.decode(Double.self, forKey: .timestamp) {
            self.timestamp = Date(timeIntervalSince1970: timestampDouble)
        } else {
            self.timestamp = Date()
        }
    }
}

