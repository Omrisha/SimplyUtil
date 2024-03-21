//
//  GraphQLAPI.swift
//  simplyutil
//
//  Created by Omri Shapira on 21/03/2024.
//

import Foundation

class GraphQLAPI {
    func performOperation<Output: Decodable>(_ operation: GraphQLOperation) async throws -> Output {
        // Get the URLRequest from the provided operation
        let request: URLRequest = try operation.getURLRequest()

        // Make the API call
        let (data, _) = try await URLSession.shared.getData(from: request)
        
        // Attempt to parse into our `Output`
        let result = try JSONDecoder().decode(GraphQLResult<Output>.self, from: data)
        guard let object = result.object else {
            print(result.errorMessages.joined(separator: "\n"))
            throw NSError(domain: "Error", code: 1)
        }
        
        return object
    }
}
