//
//  ForecastData.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI

struct ForecastData: Identifiable {
    var id = UUID()
    var date: String
    var degrees: String
    var symbol: String
}
