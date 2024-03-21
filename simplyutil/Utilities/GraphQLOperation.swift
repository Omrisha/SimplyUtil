//
//  GraphQLOperation.swift
//  simplyutil
//
//  Created by Omri Shapira on 21/03/2024.
//

import Foundation

struct GraphQLOperation : Encodable {
    var operationString: String
    
    private let url = URL(string: "https://simplyutil.herokuapp.com/graphql")!
    
    enum CodingKeys: String, CodingKey {
        case variables
        case query
    }
    
    init(_ operationString: String) {
        self.operationString = operationString
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
    static var LIST_CITIES: Self {
        GraphQLOperation("{cityAndRates {country currency threeLetterCode id name}}")
    }
    
    static var WEATHER: Self {
        GraphQLOperation("{weather(filter: {cityName:\"Tel Aviv\"}) {current {temperatureCelcius temperatureFarenheit condition {text icon}}forecast {forecasts {date day {maxTemperatureCelcius maxTemperatureFarenheit minTemperatureCelcius minTemperatureFarenheit averageTemperatureCelcius averageTemperatureFarenheit condition {text icon}}}}}}")
    }
}
