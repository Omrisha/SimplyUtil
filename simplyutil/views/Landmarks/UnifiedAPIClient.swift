//
//  UnifiedAPIClient.swift
//  simplyutil
//
//  Created by Assistant on 13/02/2026.
//

import Foundation

/// Unified API client that communicates with your backend server
/// instead of calling multiple third-party APIs directly
class UnifiedAPIClient {
    
    // Replace with your server URL
    private let baseURL = "https://your-server.com/api"
    
    // MARK: - Fetch All City Data
    
    /// Fetches all data for a city in a single request
    func fetchCityData(cityName: String, country: String) async throws -> CityData {
        let endpoint = "\(baseURL)/city/\(cityName)/\(country)"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(CityData.self, from: data)
    }
    
    // MARK: - Individual Endpoints (if needed)
    
    /// Fetches only landmarks for a city
    func fetchLandmarks(cityName: String, country: String) async throws -> [Landmark] {
        let endpoint = "\(baseURL)/landmarks?city=\(cityName)&country=\(country)"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(LandmarksResponse.self, from: data)
        return response.landmarks
    }
    
    /// Fetches weather data for a city
    func fetchWeather(cityName: String) async throws -> [WeatherForecast] {
        let endpoint = "\(baseURL)/weather?city=\(cityName)"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return response.forecasts
    }
    
    /// Fetches exchange rates for a currency
    func fetchRates(currency: String) async throws -> [String: Double] {
        let endpoint = "\(baseURL)/rates/\(currency)"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(RatesResponse.self, from: data)
        return response.rates
    }
    
    /// Fetches list of all cities/countries
    func fetchCities() async throws -> [CityDTO] {
        let endpoint = "\(baseURL)/cities"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(CitiesResponse.self, from: data)
        return response.cities
    }
}

// MARK: - Response Models

/// Combined response with all city data
struct CityData: Codable {
    let landmarks: [Landmark]
    let weather: [WeatherForecast]
    let rates: [String: Double]
    let lastUpdated: Date
}

struct LandmarksResponse: Codable {
    let landmarks: [Landmark]
}

struct WeatherResponse: Codable {
    let forecasts: [WeatherForecast]
}

struct WeatherForecast: Codable {
    let date: Date
    let temperature: Double
    let condition: String
}

struct RatesResponse: Codable {
    let baseCurrency: String
    let rates: [String: Double]
    let timestamp: Date
}

struct CitiesResponse: Codable {
    let cities: [CityDTO]
    let count: Int
}
