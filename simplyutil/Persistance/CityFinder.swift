//
//  CityFinder.swift
//  simplyutil
//
//  Created by Omri Shapira on 02/11/2021.
//

import SwiftUI
import Combine
import MapKit

class CityFinder : NSObject, ObservableObject {
    @Published var results: [String] = []
    
    private var searcher: MKLocalSearchCompleter
    
    override init() {
        results = []
        searcher = MKLocalSearchCompleter()
        super.init()
        searcher.resultTypes = .address
        searcher.delegate = self
    }
    
    func search(_ text: String) {
        searcher.queryFragment = text
    }
}

extension CityFinder: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results.map({ $0.title })
    }
}
