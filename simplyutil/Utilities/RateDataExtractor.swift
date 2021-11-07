//
//  RateDataExtractor.swift
//  simplyutil
//
//  Created by Omri Shapira on 07/11/2021.
//

import Foundation

class RateDataExtractor {
    func getRates(_ data: Data) -> [String] {
        if let rates = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String] {
            return rates
        }
        
        return []
    }
}
