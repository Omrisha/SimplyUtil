//
//  GraphQLOperation.swift
//  simplyutil
//
//  Created by Omri Shapira on 21/03/2024.
//

import Foundation

struct GraphQLOperation : Encodable {
    var operationString: String
    var variables: [Any]?
    
    // Changed to the free Countries GraphQL API
    private let url = URL(string: "https://countries.trevorblades.com/graphql")!
    
    enum CodingKeys: String, CodingKey {
        case variables
        case query
        case variable
    }
    
    init(_ operationString: String, variables: [Any]? = nil) {
        self.operationString = operationString
        self.variables = variables
        
        if let vars = variables {
            for variable in vars {
                let replacedOperationString = self.operationString.replacingOccurrences(of: "\\$\\w+", with: "\(variable)", options: .regularExpression)
                self.operationString = replacedOperationString
            }
        }
        print(self.operationString)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(operationString, forKey: .query)
        
    }
    
    func getURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(self)
    
        return request
    }
}

extension GraphQLOperation {
    // Updated query for the Countries GraphQL API
    // Note: This API provides countries, not cities with rates
    static var LIST_CITIES: Self {
        GraphQLOperation("""
        {
            countries {
                code
                name
                currency
                capital
                emoji
                continent {
                    name
                }
            }
        }
        """)
    }
}

// New struct for weather using Open-Meteo REST API (free, no API key required)
struct WeatherOperation {
    let latitude: Double
    let longitude: Double
    
    private var url: URL {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "hourly", value: "temperature_2m,relative_humidity_2m,wind_speed_10m"),
            URLQueryItem(name: "forecast_days", value: "1")
        ]
        return components.url!
    }
    
    func getURLRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    // Static factory method to match your original API style
    static func WEATHER(latitude: Double, longitude: Double) -> WeatherOperation {
        WeatherOperation(latitude: latitude, longitude: longitude)
    }
}
// Weather response models for Open-Meteo API
struct WeatherResponse: Codable {
    let latitude: Double
    let longitude: Double
    let hourly: HourlyWeather
    
    struct HourlyWeather: Codable {
        let time: [String]
        let temperature_2m: [Double]
        let wind_speed_10m: [Double]
        let relative_humidity_2m: [Int]
        
        // Computed properties to match your original naming convention
        var temperature: [Double] { temperature_2m }
        var windSpeed: [Double] { wind_speed_10m }
        var relativeHumidity: [Int] { relative_humidity_2m }
    }
}

// New struct for fetching cities using multiple fallback APIs
struct CitiesOperation {
    
    // Fetches countries with their capital cities and currencies
    static func fetchCities() async throws -> [CityDTO] {
        // Try method 1: REST Countries API with different endpoint
        do {
            return try await fetchFromRestCountries()
        } catch {
            print("REST Countries API failed: \(error.localizedDescription)")
            print("Trying fallback method...")
            
            // Try method 2: Countries Now API (alternative)
            return try await fetchFromCountriesNow()
        }
    }
    
    // Method 1: REST Countries API (official v3.1)
    private static func fetchFromRestCountries() async throws -> [CityDTO] {
        let countriesURL = URL(string: "https://restcountries.com/v3.1/all?fields=name,cca3,capital,currencies")!
        
        print("Fetching countries from REST Countries API...")
        
        var request = URLRequest(url: countriesURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 30
        
        let (countriesData, response) = try await URLSession.shared.data(for: request)
        
        // Check HTTP response
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
            guard httpResponse.statusCode == 200 else {
                throw NSError(domain: "CitiesOperation", code: httpResponse.statusCode, 
                            userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"])
            }
        }
        
        // Debug: Print raw response
        if let jsonString = String(data: countriesData, encoding: .utf8) {
            print("Response preview: \(jsonString.prefix(200))...")
        }
        
        let decoder = JSONDecoder()
        let countries = try decoder.decode([RestCountry].self, from: countriesData)
        print("Successfully decoded \(countries.count) countries")
        
        return convertToDTO(countries: countries)
    }
    
    // Method 2: Fallback using a simpler hardcoded list of major cities
    private static func fetchFromCountriesNow() async throws -> [CityDTO] {
        print("Using hardcoded major cities as fallback...")
        
        // Hardcoded list of major countries/cities with their currencies
        let majorCities: [(name: String, country: String, code: String, currency: String)] = [
            ("Washington D.C.", "United States", "USA", "USD"),
            ("London", "United Kingdom", "GBR", "GBP"),
            ("Berlin", "Germany", "DEU", "EUR"),
            ("Paris", "France", "FRA", "EUR"),
            ("Rome", "Italy", "ITA", "EUR"),
            ("Madrid", "Spain", "ESP", "EUR"),
            ("Tokyo", "Japan", "JPN", "JPY"),
            ("Beijing", "China", "CHN", "CNY"),
            ("Ottawa", "Canada", "CAN", "CAD"),
            ("Canberra", "Australia", "AUS", "AUD"),
            ("Mexico City", "Mexico", "MEX", "MXN"),
            ("Brasília", "Brazil", "BRA", "BRL"),
            ("Buenos Aires", "Argentina", "ARG", "ARS"),
            ("New Delhi", "India", "IND", "INR"),
            ("Moscow", "Russia", "RUS", "RUB"),
            ("Seoul", "South Korea", "KOR", "KRW"),
            ("Bangkok", "Thailand", "THA", "THB"),
            ("Singapore", "Singapore", "SGP", "SGD"),
            ("Dubai", "United Arab Emirates", "ARE", "AED"),
            ("Istanbul", "Turkey", "TUR", "TRY"),
            ("Cairo", "Egypt", "EGY", "EGP"),
            ("Lagos", "Nigeria", "NGA", "NGN"),
            ("Johannesburg", "South Africa", "ZAF", "ZAR"),
            ("Stockholm", "Sweden", "SWE", "SEK"),
            ("Oslo", "Norway", "NOR", "NOK"),
            ("Copenhagen", "Denmark", "DNK", "DKK"),
            ("Zurich", "Switzerland", "CHE", "CHF"),
            ("Vienna", "Austria", "AUT", "EUR"),
            ("Warsaw", "Poland", "POL", "PLN"),
            ("Prague", "Czech Republic", "CZE", "CZK"),
        ]
        
        var cities: [CityDTO] = []
        for (index, city) in majorCities.enumerated() {
            cities.append(CityDTO(
                id: index + 1,
                name: city.name,
                threeLetterCode: city.code,
                currency: city.currency,
                country: city.country
            ))
        }
        
        print("Loaded \(cities.count) major cities")
        return cities
    }
    
    // Helper to convert REST Countries format to CityDTO
    private static func convertToDTO(countries: [RestCountry]) -> [CityDTO] {
        var cities: [CityDTO] = []
        var idCounter = 1
        
        for country in countries {
            guard let capital = country.capital?.first,
                  let currencies = country.currencies,
                  !currencies.isEmpty else { continue }
            
            if let (currencyCode, _) = currencies.first {
                let city = CityDTO(
                    id: idCounter,
                    name: capital,
                    threeLetterCode: country.cca3,
                    currency: currencyCode,
                    country: country.name.common
                )
                cities.append(city)
                idCounter += 1
            }
        }
        
        print("Created \(cities.count) city entries")
        return cities
    }
}

// Models for REST Countries API
struct RestCountry: Codable {
    let name: CountryName
    let cca3: String
    let capital: [String]?
    let currencies: [String: Currency]?
    
    struct CountryName: Codable {
        let common: String
        let official: String?
    }
    
    struct Currency: Codable {
        let name: String?
        let symbol: String?
    }
}

