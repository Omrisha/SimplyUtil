//
//  RateStore.swift
//  simplyutil
//
//  Created by Omri Shapira on 07/11/2021.
//

import SwiftUI
import Combine

class RateStore: ObservableObject {
    @Published var rates: [String] = []
    
    private let httpClient = HTTPClient()
    private let ratesExtractor = RateDataExtractor()
    
    private enum Constant {
        static let ratesApi = "https://citiesrateservice.herokuapp.com/api/cities/rates"
    }
    
    init () {
        self.rates = getRates()
    }
    
    func getRates() -> [String] {
        if let ratesData = httpClient.downloadRates(Constant.ratesApi) {
            let temp = ratesExtractor.getRates(ratesData)
            return temp
        }
        
        return []
    }
}
