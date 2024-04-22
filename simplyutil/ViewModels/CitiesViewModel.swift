//
//  CitiesViewModel.swift
//  simplyutil
//
//  Created by Omri Shapira on 18/04/2024.
//

import Foundation
import SwiftUI
import SwiftData
import Observation

@Observable
class CitiesViewModel {
    var cities: [CityEntity] = []
    private let webService = WebService()
    
}
