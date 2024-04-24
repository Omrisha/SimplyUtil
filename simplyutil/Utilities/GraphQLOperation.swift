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
    
    private let url = URL(string: "https://simplyutil.herokuapp.com/graphql")!
    
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
    static var LIST_CITIES: Self {
        GraphQLOperation("{cityAndRates {country currency threeLetterCode id name}}")
    }
    
    static func WEATHER(latitude: Double, longitude: Double) -> Self {
        GraphQLOperation("{weatherByLocation(filter: {latitude: $latitude, longitude: $longitude}) {hourly {time temperature windSpeed relativeHumidity}}}", variables: [latitude, longitude])
    }
}
