//
//  Environment.swift
//  simplyutil
//
//  Created by Omri Shapira on 30/03/2024.
//

import Foundation

public enum EnvironmentKeys {
    enum Keys {
        static let apiKey = "GooglePlacesApiKey"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    static let apiKey: String = {
        guard let apiKeyString = EnvironmentKeys.infoDictionary[Keys.apiKey] as? String else {
            fatalError("plist file not found")
        }
        return apiKeyString
    }()
}
